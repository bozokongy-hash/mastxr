-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Main Window
local Window = Fluent:CreateWindow({
    Title = "MASTXR Hub " .. Fluent.Version,
    SubTitle = "by @4503 / @bc_ieef",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    MusicalChairs = Window:AddTab({ Title = "Musical Chairs", Icon = "music" }),
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Helper for coming soon
local function ComingSoon(title)
    return function()
        Fluent:Notify({ Title = "MASTXR Hub", Content = title .. " is coming soon!", Duration = 4 })
    end
end
--[[ 
    MASTXR Hub - Musical Chairs Edition (Optimized)
    Features: Auto Sit, Speed Boost, Advanced Anti-Kick
    Author: Top1 Sweb
--]]

-- Utility: find all chairs/seats in workspace
local function getAllChairs()
    local chairs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
            table.insert(chairs, obj)
        end
    end
    return chairs
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ================== GUI Setup ==================
local gui = Instance.new("ScreenGui")
gui.Name = "MASTXRHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 160)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1,-40,0,40)
autoBtn.Position = UDim2.new(0,20,0,50)
autoBtn.Font = Enum.Font.SourceSansBold
autoBtn.TextSize = 18
autoBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Text = "🔁 Auto Sit OFF"

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1,-40,0,25)
speedLabel.Position = UDim2.new(0,20,0,100)
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 16
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"

local speedSlider = Instance.new("TextButton", frame)
speedSlider.Size = UDim2.new(1,-40,0,25)
speedSlider.Position = UDim2.new(0,20,0,125)
speedSlider.Font = Enum.Font.SourceSansBold
speedSlider.TextSize = 14
speedSlider.TextColor3 = Color3.new(1,1,1)
speedSlider.Text = "Adjust Speed"
speedSlider.BackgroundColor3 = Color3.fromRGB(80,80,80)

-- Close button logic
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ================== Anti-Kick Setup ==================
local function enableAntiKick()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt,false)
    mt.__namecall = newcclosure(function(self,...)
        local method = getnamecallmethod()
        if method == "Kick" then return nil end
        return oldNamecall(self,...)
    end)
    setreadonly(mt,true)
end

-- Player reference
local player = game.Players.LocalPlayer

-- ================= Auto Sit Toggle =================
local autoSitEnabled = false
local autoSitLoop
Tabs.MusicalChairs:AddToggle("AutoSitToggle", {
    Title = "Auto Sit",
    Default = false,
    Callback = function(state)
        autoSitEnabled = state
        if state then
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Auto Sit ON", Duration = 4 })
            autoSitLoop = task.spawn(function()
                while autoSitEnabled do
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart", 5)
                    if hrp then
                        local chairs = getAllChairs()
                        local nearest, minDist = nil, math.huge
                        for _, seat in ipairs(chairs) do
                            if seat.Occupant == nil then
                                local d = (hrp.Position - seat.Position).Magnitude
                                if d < minDist then
                                    nearest, minDist = seat, d
                                end
                            end
                        end
                        if nearest then
                            hrp.CFrame = hrp.CFrame:Lerp(nearest.CFrame + Vector3.new(0,2,0), 0.25)
                        end
                    end
                    task.wait(0.75)
enableAntiKick()

-- ================== Auto Sit Logic ==================
local autoEnabled = false
local autoLoop
local function getTargetChair()
    local spinner = workspace:FindFirstChild("SpinnerStuff")
    if spinner and spinner:FindFirstChild("ChairSpots") then
        for _, spot in pairs(spinner.ChairSpots:GetChildren()) do
            if spot:FindFirstChild("ChairParts") and spot.ChairParts:FindFirstChild("Cushion") then
                local cushion = spot.ChairParts.Cushion
                if cushion and not cushion.Occupant then
                    return cushion
                end
            end)
        else
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Auto Sit OFF", Duration = 4 })
            if autoSitLoop then task.cancel(autoSitLoop) end
            end
        end
    end
})

-- ================= Speed Boost Slider =================
Tabs.MusicalChairs:AddSlider("SpeedSlider", {
    Title = "Speed Boost",
    Description = "Adjust WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- ================= Anti-Kick Toggle =================
Tabs.MusicalChairs:AddToggle("AntiKickToggle", {
    Title = "Anti-Kick",
    Default = false,
    Callback = function(state)
        if state then
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt,false)
            mt.__namecall = newcclosure(function(self,...)
                local method = getnamecallmethod()
                if method == "Kick" then return nil end
                return oldNamecall(self,...)
            end)
            setreadonly(mt,true)
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Anti-Kick enabled", Duration = 5 })
        else
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Anti-Kick toggle OFF (rejoin to reset)", Duration = 5 })
        end
    end
})

-- ================= Chair Reservation Toggle =================
local chairReserveEnabled = false
local chairReserveLoop

Tabs.MusicalChairs:AddToggle("ChairReserveToggle", {
    Title = "Chair Reservation",
    Default = false,
    Callback = function(state)
        chairReserveEnabled = state
        if state then
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Chair Reservation ON", Duration = 4 })
            chairReserveLoop = task.spawn(function()
                while chairReserveEnabled do
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart", 5)
                    local chairs = getAllChairs()
                    local target, minDist = nil, math.huge
                    -- pick nearest empty chair
                    for _, seat in ipairs(chairs) do
                        if seat.Occupant == nil then
                            local d = (hrp.Position - seat.Position).Magnitude
                            if d < minDist then
                                target, minDist = seat, d
                            end
                        end
                    end
                    if target then
                        -- move to chair
                        hrp.CFrame = hrp.CFrame:Lerp(target.CFrame + Vector3.new(0,2,0), 0.3)
                        -- briefly "sit" then release
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.Sit = true
                            task.wait(0.25)
                            humanoid.Sit = false
                        end
                    end
                    task.wait(0.75)
    return nil
end

local function smoothTeleport(targetPos)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local offset = Vector3.new(math.random()*0.5, 0, math.random()*0.5)
    root.CFrame = root.CFrame:Lerp(targetPos + Vector3.new(0,5,0) + offset, 0.35)
end

autoBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    autoBtn.Text = autoEnabled and "🔁 Auto Sit ON" or "🔁 Auto Sit OFF"

    if autoEnabled then
        autoLoop = task.spawn(function()
            while autoEnabled do
                local target = getTargetChair()
                if target then
                    smoothTeleport(target.Position)
                end
            end)
        else
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Chair Reservation OFF", Duration = 4 })
            if chairReserveLoop then task.cancel(chairReserveLoop) end
        end
                task.wait(0.7 + math.random()*0.3) -- randomized delay
            end
        end)
    else
        if autoLoop then task.cancel(autoLoop) end
    end
})

-- Placeholder for future feature
Tabs.MusicalChairs:AddButton({
    Title = "Extra Feature",
    Description = "Coming Soon",
    Callback = ComingSoon("Extra Feature")
})

-- ================= Settings Tab =================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MASTXRHub")
SaveManager:SetFolder("MASTXRHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Tabs.Settings:AddButton({
    Title = "Join our Discord",
    Icon = "discord",
    Description = "Click to copy the invite",
    Callback = function()
        local invite = "https://discord.gg/s2QBMdTF6G"
        pcall(function() if setclipboard then setclipboard(invite) end end)
        Fluent:Notify({ Title = "MASTXR Hub", Content = "Discord invite copied!", SubContent = invite, Duration = 6 })
end)

-- ================== Speed Slider Logic ==================
local currentSpeed = 16
speedSlider.MouseButton1Click:Connect(function()
    -- prompt user for speed or cycle through preset values
    currentSpeed = currentSpeed + 10
    if currentSpeed > 100 then currentSpeed = 16 end
    speedLabel.Text = "Speed: "..currentSpeed
    -- Gradual ramp
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        task.spawn(function()
            local step = (currentSpeed - hum.WalkSpeed)/5
            for i=1,5 do
                hum.WalkSpeed = hum.WalkSpeed + step
                task.wait(0.05)
            end
            hum.WalkSpeed = currentSpeed
        end)
    end
})
end)

-- ================== Final Notification ==================
local function notify(msg)
    local notif = Instance.new("TextLabel", frame)
    notif.Size = UDim2.new(1,-40,0,25)
    notif.Position = UDim2.new(0,20,0,frame.Size.Y.Offset - 30)
    notif.BackgroundTransparency = 0.5
    notif.BackgroundColor3 = Color3.fromRGB(0,0,0)
    notif.TextColor3 = Color3.new(1,1,1)
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 14
    notif.Text = msg
    task.delay(3,function() notif:Destroy() end)
end

-- ================= Default Tab & Notify =================
Window:SelectTab(1)
Fluent:Notify({ Title = "MASTXR Hub", Content = "Musical Chairs Hub Loaded!", Duration = 8 })
SaveManager:LoadAutoloadConfig()
notify("MASTXR Hub Loaded! Auto Sit + Speed Boost Active")
