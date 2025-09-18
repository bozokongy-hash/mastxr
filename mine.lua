-- Sweb Hub - Steal-a-Jeffy Tools (Injected Tab)
-- Loads SwebHub/Orion-like GUI and injects many features for Steal-a-Jeffy.
-- Replace the loader URL with your hub if needed.

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/adminabuser/terst/refs/heads/main/source.lua'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- ---------- Helpers ----------
local function getChar(plr) plr = plr or LocalPlayer return plr.Character or plr.CharacterAdded:Wait() end
local function getHumanoid(plr) local c = getChar(plr) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRootPart(plr) local c = getChar(plr) if not c then return nil end return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") end
local function isAlive(plr) local hum = getHumanoid(plr) return hum and hum.Health > 0 end

-- find nearest BasePart by name pattern (case-insensitive)
local function findNearestByName(pattern, range)
    local lpRoot = getRootPart(LocalPlayer)
    if not lpRoot then return nil, math.huge end
    local nearest, ndist = nil, math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nm = tostring(obj.Name):lower()
            if nm:find(pattern:lower()) then
                local dist = (obj.Position - lpRoot.Position).Magnitude
                if dist < ndist and dist <= (range or 300) then
                    nearest, ndist = obj, dist
                end
            end
        end
    end
    return nearest, ndist
end

-- search guessed remotes in ReplicatedStorage & Workspace and call them with `arg` if present
local function tryCallRemoteWithGuesses(arg, guesses)
    guesses = guesses or {}
    local searchRoots = {ReplicatedStorage, Workspace}
    for _, root in ipairs(searchRoots) do
        for _, r in ipairs(root:GetDescendants()) do
            if (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
                local lname = tostring(r.Name):lower()
                for _, g in ipairs(guesses) do
                    if lname:find(g:lower()) then
                        local ok, _ = pcall(function()
                            if r:IsA("RemoteEvent") then
                                if arg ~= nil then r:FireServer(arg) else r:FireServer() end
                            else
                                if arg ~= nil then r:InvokeServer(arg) else r:InvokeServer() end
                            end
                        end)
                        if ok then return true end
                    end
                end
            end
        end
    end
    return false
end

-- teleport to item and try to touch (fallback)
local function teleportToAndTouch(item)
    if not item or not item:IsA("BasePart") then return false end
    local hrp = getRootPart(LocalPlayer)
    if not hrp then return false end
    local original = hrp.CFrame
    pcall(function()
        hrp.CFrame = item.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.12)
        pcall(function() item:Touch() end)
        task.wait(0.12)
        hrp.CFrame = original
    end)
    return true
end

-- small utility notification via Orion
local function notify(title, text, time)
    time = time or 4
    pcall(function() OrionLib:MakeNotification({Name = title or "SwebHub", Content = text or "", Time = time}) end)
end

-- ---------- Window & Tab ----------
local Window = OrionLib:MakeWindow({
    Name = "Sweb Hub - Steal a Jeffy Tools",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "SwebHubConfig",
    IntroEnabled = false
})

local tab = Window:MakeTab({Name = "Steal-a-Jeffy Tools", Icon = "rbxassetid://4483345998"})
local settingsTab = Window:MakeTab({Name = "Steal-a-Jeffy Settings", Icon = "rbxassetid://6023426915"})

-- ---------- Config / State ----------
local cfg = {
    autoStealer = false,
    stealRange = 80,
    autoPickBrainrot = false,
    brainRange = 200,
    autoFarm = false,
    farmRange = 150,
    espEnemies = false,
    speedEnabled = false,
    walkspeed = 16,
    noclip = false,
    dupeGuesses = {"DupePet","Dupe","DuplicatePet"},
    pickupGuesses = {"PickupJeffy","Pickup","Collect","CollectItem","Steal","TouchItem"},
    brainrotGuesses = {"PickupBrainrot","PickBrainrot","CollectBrainrot","Collect"},
    adminGuesses = {"AdminCommand","RunCommand","Execute","Admin"},
    farmGuesses = {"Farm","Harvest","Collect","CollectItem"},
    lastSteal = 0
}

-- ---------- DUPE PET ----------
tab:AddButton({
    Name = "DUPE PET (attempt)",
    Callback = function()
        local ok = tryCallRemoteWithGuesses(nil, cfg.dupeGuesses)
        if ok then notify("Dupe", "Dupe remote called (guess).", 4)
        else notify("Dupe", "No dupe remote found. Need exact remote/args.", 4) end
    end
})

-- ---------- AUTO STEALER (Jeffy) ----------
tab:AddToggle({
    Name = "Auto Stealer (Jeffy)",
    Default = false,
    Callback = function(v) cfg.autoStealer = v end
})
tab:AddSlider({
    Name = "Steal Range",
    Min = 10, Max = 500, Default = cfg.stealRange, Increment = 5,
    Callback = function(v) cfg.stealRange = v end
})
tab:AddButton({
    Name = "Force Steal Now",
    Callback = function()
        local item, dist = findNearestByName("jeffy", cfg.stealRange)
        if item then
            local success = tryCallRemoteWithGuesses(item, cfg.pickupGuesses) or teleportToAndTouch(item)
            notify("Steal", success and "Attempted steal." or "Steal attempt failed.", 3)
        else
            notify("Steal", "No Jeffy found in range.", 3)
        end
    end
})

-- ---------- VISUAL ENEMY (ESP) ----------
local espTable = {}
local function createESPForPlayer(p)
    if not p.Character then return end
    local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
    if not root then return end
    if root:FindFirstChild("SwebESP") then return end
    local gui = Instance.new("BillboardGui")
    gui.Name = "SwebESP"
    gui.Adornee = root
    gui.Size = UDim2.new(0,120,0,40)
    gui.AlwaysOnTop = true
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = p.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255,80,80)
    gui.Parent = root
    espTable[p] = gui
end

local function clearESP()
    for p, gui in pairs(espTable) do
        if gui and gui.Parent then pcall(function() gui:Destroy() end) end
    end
    espTable = {}
end

tab:AddToggle({
    Name = "Visual Enemy (ESP)",
    Default = false,
    Callback = function(v)
        cfg.espEnemies = v
        if not v then clearESP() end
    end
})

-- auto-add ESP for joining players
Players.PlayerAdded:Connect(function(plr)
    if cfg.espEnemies then
        task.wait(0.6)
        if plr ~= LocalPlayer and isAlive(plr) then createESPForPlayer(plr) end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espTable[plr] then pcall(function() espTable[plr]:Destroy() end) espTable[plr] = nil end
end)

-- ---------- BASE TIME INDICATOR ----------
local baseGui = Instance.new("ScreenGui")
baseGui.Name = "SwebBaseTime"
local timeLabel = Instance.new("TextLabel", baseGui)
timeLabel.Size = UDim2.new(0,220,0,28)
timeLabel.Position = UDim2.new(0,10,0,10)
timeLabel.BackgroundTransparency = 0.4
timeLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
timeLabel.TextColor3 = Color3.fromRGB(255,255,255)
timeLabel.Font = Enum.Font.GothamBold
timeLabel.TextSize = 14
timeLabel.Text = "Base Time (UTC): --:--:--"
baseGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

-- ---------- ADMIN COMMANDS ----------
local adminBox = tab:AddTextbox({Name = "Admin Command", Default = "", TextDisappear = false, Callback = function(v) end})
tab:AddButton({
    Name = "Send Admin Command (guess)",
    Callback = function()
        local cmd = adminBox:GetValue and adminBox:GetValue() or adminBox.Value or ""
        if type(cmd) ~= "string" or cmd:match("^%s*$") then notify("Admin", "Type a command in the box.", 3); return end
        local ok = tryCallRemoteWithGuesses(cmd, cfg.adminGuesses)
        notify("Admin", ok and "Admin command sent (guess)." or "No admin remote found / command failed.", 4)
    end
})

-- ---------- AUTO FARM ----------
tab:AddToggle({Name = "Auto Farm", Default = false, Callback = function(v) cfg.autoFarm = v end})
tab:AddSlider({Name = "Auto Farm Range", Min = 10, Max = 800, Default = cfg.farmRange, Increment = 5, Callback = function(v) cfg.farmRange = v end})
tab:AddButton({Name = "Force Farm Now", Callback = function()
    local obj, d = findNearestByName("farm", cfg.farmRange)
    if obj then
        local ok = tryCallRemoteWithGuesses(obj, cfg.farmGuesses) or teleportToAndTouch(obj)
        notify("Farm", ok and "Attempted farm." or "Farm attempt failed.", 3)
    else
        notify("Farm", "No farmable found (guess).", 3)
    end
end})

-- ---------- AUTO PICK BRAINROT ----------
tab:AddToggle({Name = "Auto Pick Brainrot", Default = false, Callback = function(v) cfg.autoPickBrainrot = v end})
tab:AddSlider({Name = "Brainrot Range", Min = 10, Max = 600, Default = cfg.brainRange, Increment = 5, Callback = function(v) cfg.brainRange = v end})

-- ---------- TELEPORT ----------
local teleportBox = tab:AddTextbox({Name = "Teleport Coordinates (x,y,z)", Default = "", TextDisappear = false, Callback = function(v) end})
tab:AddButton({Name = "Teleport to Coords", Callback = function()
    local val = (teleportBox.GetValue and teleportBox:GetValue()) or teleportBox.Value or teleportBox.Text or ""
    if type(val) ~= "string" or val == "" then notify("Teleport", "Enter x,y,z in textbox.", 3); return end
    local x,y,z = string.match(val, "([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)")
    if not x then notify("Teleport", "Bad coords format. Use: x,y,z", 3); return end
    local hrp = getRootPart(LocalPlayer)
    if hrp then pcall(function() hrp.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z)) end) end
end})
tab:AddButton({Name = "Teleport to Mouse", Callback = function()
    local mouse = LocalPlayer:GetMouse()
    if not mouse then notify("Teleport", "Unable to access mouse.", 3); return end
    local hit = mouse.Hit
    local hrp = getRootPart(LocalPlayer)
    if hrp and hit then pcall(function() hrp.CFrame = CFrame.new(hit.p + Vector3.new(0,3,0)) end) end
end})

-- ---------- NOCLIP (with restore) ----------
local noclipConn = nil
local savedCollisions = {}
local function enableNoclip()
    -- save current state
    savedCollisions = {}
    local c = getChar()
    if not c then return end
    for _, part in ipairs(c:GetDescendants()) do
        if part:IsA("BasePart") then
            savedCollisions[part] = part.CanCollide
        end
    end
    -- apply noclip each step
    noclipConn = RunService.Stepped:Connect(function()
        local c = getChar()
        if c then
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
    end)
end
local function disableNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    -- restore saved states
    for part, val in pairs(savedCollisions) do
        if part and part.Parent then
            pcall(function() part.CanCollide = val end)
        end
    end
    savedCollisions = {}
end

tab:AddToggle({Name = "Noclip (restore safe)", Default = false, Callback = function(v)
    cfg.noclip = v
    if v then enableNoclip() else disableNoclip() end
end})

-- ---------- SPEED ----------
tab:AddToggle({Name = "Enable Speed", Default = false, Callback = function(v) cfg.speedEnabled = v end})
tab:AddSlider({Name = "WalkSpeed", Min = 16, Max = 300, Default = cfg.walkspeed, Increment = 1, Callback = function(v) cfg.walkspeed = v end})

-- ---------- Runtime loops ----------
task.spawn(function()
    while true do
        task.wait(0.25)
        -- Walkspeed
        local hum = getHumanoid(LocalPlayer)
        if hum then
            pcall(function()
                if cfg.speedEnabled then hum.WalkSpeed = cfg.walkspeed or 16 else hum.WalkSpeed = 16 end
            end)
        end

        -- Auto Stealer
        if cfg.autoStealer then
            if tick() - cfg.lastSteal < 0.9 then goto CONT_STEAL end
            local item, dist = findNearestByName("jeffy", cfg.stealRange)
            if item then
                cfg.lastSteal = tick()
                local ok = tryCallRemoteWithGuesses(item, cfg.pickupGuesses)
                if not ok then pcall(function() teleportToAndTouch(item) end) end
                task.wait(0.5)
            end
        end
        ::CONT_STEAL::

        -- Auto Pick Brainrot
        if cfg.autoPickBrainrot then
            local b, d = findNearestByName("brainrot", cfg.brainRange)
            if b then
                local ok = tryCallRemoteWithGuesses(b, cfg.brainrotGuesses)
                if not ok then teleportToAndTouch(b) end
                task.wait(0.6)
            end
        end

        -- Auto Farm
        if cfg.autoFarm then
            local f, d = findNearestByName("farm", cfg.farmRange)
            if f then
                local ok = tryCallRemoteWithGuesses(f, cfg.farmGuesses)
                if not ok then teleportToAndTouch(f) end
                task.wait(0.6)
            end
        end
    end
end)

-- ESP render (clean + update)
RunService.RenderStepped:Connect(function()
    -- update time label (UTC)
    if timeLabel then
        local t = os.date("!*t")
        timeLabel.Text = string.format("Base Time (UTC): %02d:%02d:%02d", t.hour, t.min, t.sec)
    end

    -- ESP
    if cfg.espEnemies then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and isAlive(plr) then
                if not espTable[plr] then createESPForPlayer(plr) end
            else
                if espTable[plr] then pcall(function() espTable[plr]:Destroy() end) espTable[plr] = nil end
            end
        end
    end
end)

-- Initialize Orion (if required)
if OrionLib.Init then pcall(function() OrionLib:Init() end) end

print("[SwebHub] Steal-a-Jeffy Tools injected and running.")
