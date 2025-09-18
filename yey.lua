-- Sweb Hub - Sweb Tools (injected tab with requested features)
-- Loader URL: replace if you host your own SwebHub
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/adminabuser/terst/refs/heads/main/source.lua'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- basic helpers
local function getChar(plr) plr = plr or LocalPlayer return plr.Character or plr.CharacterAdded:Wait() end
local function getRootPart(plr) local c = getChar(plr) if not c then return nil end return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") end
local function getHumanoid(plr) local c = getChar(plr) return c and c:FindFirstChildOfClass("Humanoid") end
local function isAlive(plr) local hum = getHumanoid(plr) return hum and hum.Health > 0 end

-- find nearest by name pattern
local function findNearestByName(pattern, range)
    local lpRoot = getRootPart(LocalPlayer)
    if not lpRoot then return nil, math.huge end
    local nearest, ndist = nil, math.huge
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = tostring(obj.Name):lower()
            if name:find(pattern:lower()) then
                local dist = (obj.Position - lpRoot.Position).Magnitude
                if dist < ndist and dist <= (range or 200) then
                    nearest, ndist = obj, dist
                end
            end
        end
    end
    return nearest, ndist
end

-- general remote caller (searches guessed names in ReplicatedStorage & Workspace)
local function tryCallRemoteWithGuesses(item, guesses)
    guesses = guesses or {}
    local searchRoots = {game:GetService("ReplicatedStorage"), Workspace}
    for _, root in ipairs(searchRoots) do
        for _, r in ipairs(root:GetDescendants()) do
            if (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
                local lname = tostring(r.Name):lower()
                for _, g in ipairs(guesses) do
                    if lname:find(g:lower()) then
                        local ok, res = pcall(function()
                            if r:IsA("RemoteEvent") then
                                r:FireServer(item)
                            else
                                r:InvokeServer(item)
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

-- teleport-to-touch fallback
local function teleportToAndTouch(item)
    if not item or not item:IsA("BasePart") then return false end
    local hrp = getRootPart(LocalPlayer)
    if not hrp then return false end
    local original = hrp.CFrame
    hrp.CFrame = item.CFrame + Vector3.new(0,2,0)
    task.wait(0.12)
    pcall(function() item:Touch() end)
    task.wait(0.12)
    pcall(function() hrp.CFrame = original end)
    return true
end

-- Create Window & Tab
local Window = OrionLib:MakeWindow({
    Name = "Sweb Hub - Tools",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "SwebHubConfig",
    IntroEnabled = false
})

local tab = Window:MakeTab({Name="Sweb Tools", Icon="rbxassetid://4483345998"})
local settingsTab = Window:MakeTab({Name="Sweb Tools - Settings", Icon="rbxassetid://6023426915"})

-- config / states
local cfg = {
    autoStealer = false,
    autoFarm = false,
    autoPickBrainrot = false,
    espEnemies = false,
    noclip = false,
    speedEnabled = false,
    walkspeed = 16,
    dupeGuesses = {"DupePet", "Dupe", "PetDupe"},
    stealerNames = {"jeffy", "item", "pickup"},
    farmNames = {"FarmSpot", "Crop", "Tree", "Farmable"},
    brainrotNames = {"brainrot", "brain rot"},
    adminGuesses = {"Admin", "RunCommand", "Execute", "AdminCmd"}
}

-- ---------- DUPE PET ----------
tab:AddButton({
    Name = "DUPE PET (attempt)",
    Callback = function()
        -- This is a generic attempt: find remote with guessed names and call with no args.
        local ok = tryCallRemoteWithGuesses(nil, cfg.dupeGuesses)
        if ok then
            OrionLib:MakeNotification({Name="SwebHub", Content="Dupe remote called (guess).", Time=3})
        else
            OrionLib:MakeNotification({Name="SwebHub", Content="No dupe remote found. You must supply the remote name.", Time=3})
        end
    end
})

-- ---------- AUTO STEALER ----------
tab:AddToggle({
    Name = "Auto Stealer",
    Default = false,
    Callback = function(v) cfg.autoStealer = v end
})
tab:AddSlider({
    Name = "Auto Steal Range",
    Min = 10, Max = 500, Default = 80, Increment = 5,
    Callback = function(v) cfg.stealRange = v end
})
tab:AddButton({
    Name = "Force Steal Now",
    Callback = function()
        local item, dist = findNearestByName("jeffy", cfg.stealRange or 80)
        if item then
            local success = tryCallRemoteWithGuesses(item, {"pickup", "Collect", "CollectItem", "PickupItem"}) or teleportToAndTouch(item)
            OrionLib:MakeNotification({Name="SwebHub", Content = success and "Attempted steal." or "Steal failed.", Time=3})
        else
            OrionLib:MakeNotification({Name="SwebHub", Content = "No target found.", Time=3})
        end
    end
})

-- ---------- VISUAL ENEMY (ESP) ----------
local espEntries = {}
local function createESPForPlayer(p)
    if not p.Character then return end
    local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
    if not root then return end
    if root:FindFirstChild("SwebESP") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SwebESP"
    billboard.Adornee = root
    billboard.Size = UDim2.new(0,120,0,40)
    billboard.AlwaysOnTop = true
    local t = Instance.new("TextLabel", billboard)
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text = p.Name
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.TextColor3 = Color3.new(1,0.2,0.2)
    billboard.Parent = root
    espEntries[p] = billboard
end

local function clearAllESP()
    for p,b in pairs(espEntries) do
        if b and b.Parent then b:Destroy() end
    end
    espEntries = {}
end

tab:AddToggle({
    Name = "Visual Enemy (ESP)",
    Default = false,
    Callback = function(v)
        cfg.espEnemies = v
        if not v then clearAllESP() end
    end
})

-- ---------- BASE TIME INDICATOR ----------
-- simple label in StarterGui showing uptime / server time approximation
local baseTimeLabel
do
    local StarterGui = game:GetService("StarterGui")
    baseTimeLabel = Instance.new("ScreenGui")
    baseTimeLabel.Name = "SwebBaseTime"
    local t = Instance.new("TextLabel", baseTimeLabel)
    t.Size = UDim2.new(0,220,0,28)
    t.Position = UDim2.new(0,10,0,10)
    t.BackgroundTransparency = 0.4
    t.BackgroundColor3 = Color3.fromRGB(20,20,20)
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Text = "Base Time: 00:00:00"
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    baseTimeLabel.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end

RunService.RenderStepped:Connect(function()
    if baseTimeLabel and baseTimeLabel:FindFirstChildOfClass("TextLabel") then
        local tl = baseTimeLabel:FindFirstChildOfClass("TextLabel")
        local h = os.date("!*t").hour -- UTC as a fallback
        local m = os.date("!*t").min
        local s = os.date("!*t").sec
        tl.Text = string.format("Base Time (UTC): %02d:%02d:%02d", h, m, s)
    end
end)

-- ---------- ADMIN COMMANDS ----------
local adminTextbox = tab:AddTextbox({Name="Admin Command", Default="", TextDisappear=false, Callback=function(v) end})
tab:AddButton({Name="Send Admin Command (guess)", Callback=function()
    local cmd = adminTextbox:GetValue() or ""
    if cmd == "" then OrionLib:MakeNotification({Name="SwebHub", Content="Type a command in the box.", Time=3}); return end
    local ok = false
    -- attempt to find admin remotes and send the command as string
    ok = tryCallRemoteWithGuesses(cmd, cfg.adminGuesses)
    OrionLib:MakeNotification({Name="SwebHub", Content = ok and "Command sent (guess)." or "No admin remote found or command failed.", Time=4})
end})

-- ---------- AUTO FARM ----------
tab:AddToggle({Name="Auto Farm", Default=false, Callback=function(v) cfg.autoFarm=v end})
tab:AddSlider({Name="Auto Farm Range", Min=10, Max=800, Default=150, Increment=5, Callback=function(v) cfg.farmRange=v end})
tab:AddButton({Name="Force Farm Now", Callback=function()
    local obj, d = findNearestByName("farm", cfg.farmRange or 150)
    if obj then
        local ok = tryCallRemoteWithGuesses(obj, {"Farm", "Collect", "Harvest"}) or teleportToAndTouch(obj)
        OrionLib:MakeNotification({Name="SwebHub", Content = ok and "Tried farming." or "Farm failed.", Time=3})
    else
        OrionLib:MakeNotification({Name="SwebHub", Content = "No farmable found.", Time=3})
    end
end})

-- ---------- AUTO PICK BRAINROT ----------
tab:AddToggle({Name="Auto Pick Brainrot", Default=false, Callback=function(v) cfg.autoPickBrainrot=v end})
tab:AddSlider({Name="Brainrot Range", Min=10, Max=600, Default=200, Increment=5, Callback=function(v) cfg.brainRange=v end})

-- ---------- TELEPORT ----------
tab:AddTextbox({Name="Teleport Coordinates (x,y,z)", Default="", TextDisappear=false, Callback=function(v) end})
tab:AddButton({Name="Teleport to Coords", Callback=function()
    local txt = tab:GetChildren() -- not reliable across libs; instead get textbox value above:
    local coords = tab:GetChildren()
    -- quick find of the Textbox (best-effort)
    local foundVal
    for _, child in ipairs(tab.Container:GetChildren()) do
        if child.ClassName == "TextBox" and child.Name:find("Teleport") then foundVal = child.Text break end
    end
    local val = foundVal or "" -- fallback empty
    if val == "" then OrionLib:MakeNotification({Name="SwebHub", Content="Enter x,y,z in textbox.", Time=3}); return end
    local x,y,z = string.match(val, "([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)")
    if not x then OrionLib:MakeNotification({Name="SwebHub", Content="Bad coords format, use x,y,z", Time=3}); return end
    local hrp = getRootPart(LocalPlayer)
    if hrp then
        pcall(function() hrp.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z)) end)
    end
end})
tab:AddButton({Name="Teleport to Mouse", Callback=function()
    local mouse = LocalPlayer:GetMouse()
    local hit = mouse.Hit
    local hrp = getRootPart(LocalPlayer)
    if hrp and hit then
        pcall(function() hrp.CFrame = CFrame.new(hit.p + Vector3.new(0,3,0)) end)
    end
end})

-- ---------- NOCLIP ----------
tab:AddToggle({Name="Noclip", Default=false, Callback=function(v)
    cfg.noclip = v
    if v then
        -- enable noclip by setting CanCollide false on character parts
        RunService.Stepped:Connect(function()
            local c = getChar()
            if c then
                for _, part in pairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- we don't attempt to restore original collisions here - slight risk; a full restore would need saved states
    end
end})

-- ---------- SPEED ----------
tab:AddToggle({Name="Enable Speed", Default=false, Callback=function(v) cfg.speedEnabled=v end})
tab:AddSlider({Name="WalkSpeed", Min=16, Max=300, Default=16, Increment=1, Callback=function(v) cfg.walkspeed=v end})

-- ---------- RUNTIME LOOPS ----------
-- Auto-steal / auto-farm / brainrot loops
task.spawn(function()
    while true do
        task.wait(0.25)
        -- speed
        if cfg.speedEnabled then
            local hum = getHumanoid(LocalPlayer)
            if hum then
                pcall(function() hum.WalkSpeed = cfg.walkspeed or 16 end)
            end
        else
            local hum = getHumanoid(LocalPlayer)
            if hum then pcall(function() hum.WalkSpeed = 16 end) end
        end

        -- auto stealer
        if cfg.autoStealer then
            local item, dist = findNearestByName("jeffy", cfg.stealRange or 80)
            if item then
                local success = tryCallRemoteWithGuesses(item, {"pickup","collect","pickupitem"}) or teleportToAndTouch(item)
                task.wait(0.6)
            end
        end

        -- auto farm
        if cfg.autoFarm then
            local obj = findNearestByName("farm", cfg.farmRange or 150)
            if obj then
                tryCallRemoteWithGuesses(obj, {"harvest","collect","farm"})
                task.wait(0.6)
            end
        end

        -- auto pick brainrot
        if cfg.autoPickBrainrot then
            local item = findNearestByName("brainrot", cfg.brainRange or 200)
            if item then
                local ok = tryCallRemoteWithGuesses(item, {"pickup","collect","pickupitem"}) or teleportToAndTouch(item)
                task.wait(0.6)
            end
        end
    end
end)

-- ESP render loop
RunService.RenderStepped:Connect(function()
    if cfg.espEnemies then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and isAlive(p) then
                if not espEntries[p] then createESPForPlayer(p) end
            else
                if espEntries[p] then
                    if espEntries[p].Parent then espEntries[p]:Destroy() end
                    espEntries[p] = nil
                end
            end
        end
    end
end)

-- init
if OrionLib.Init then pcall(function() OrionLib:Init() end) end
print("[SwebHub] Sweb Tools injected")
