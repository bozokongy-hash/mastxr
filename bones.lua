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

-- Helper function for "Coming Soon"
local function ComingSoon(title)
    return function()
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = title .. " is coming soon!",
            Duration = 4
        })
    end
end

-- Utility to find all seats/chairs
local function getAllChairs()
    local chairs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
            table.insert(chairs, obj)
        end
    end
    return chairs
end

-- ===== Musical Chairs Tab =====
local player = game.Players.LocalPlayer
local autoSitEnabled = false
local autoSitLoop

-- Auto Sit (Toggle)
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
                            -- Smooth move instead of instant teleport (anti-cheat friendly)
                            hrp.CFrame = hrp.CFrame:Lerp(nearest.CFrame + Vector3.new(0,2,0), 0.25)
                        end
                    end
                    task.wait(0.75) -- delay between checks
                end
            end)
        else
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Auto Sit OFF", Duration = 4 })
            if autoSitLoop then
                task.cancel(autoSitLoop)
            end
        end
    end
})

-- Speed Boost (Slider + Toggle Reset)
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
Tabs.MusicalChairs:AddToggle("SpeedResetToggle", {
    Title = "Reset Speed (16)",
    Default = false,
    Callback = function(state)
        if state then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Speed reset to default!", Duration = 4 })
        end
    end
})

-- Anti-Kick (replacing ESP)
Tabs.MusicalChairs:AddToggle("AntiKickToggle", {
    Title = "Anti-Kick",
    Default = false,
    Callback = function(state)
        if state then
            -- Hook Kick methods
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    return nil
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Anti-Kick enabled", Duration = 5 })
        else
            Fluent:Notify({ Title = "MASTXR Hub", Content = "Anti-Kick toggle off (rejoin to reset hooks)", Duration = 5 })
        end
    end
})

-- Placeholder
Tabs.MusicalChairs:AddButton({
    Title = "Extra Feature",
    Description = "Coming Soon",
    Callback = ComingSoon("Musical Chairs Extra Feature")
})

-- ===== Settings Tab =====
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MASTXRHub")
SaveManager:SetFolder("MASTXRHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Discord button
Tabs.Settings:AddButton({
    Title = "Join our Discord",
    Icon = "discord",
    Description = "Click to copy the invite",
    Callback = function()
        local invite = "https://discord.gg/s2QBMdTF6G"
        pcall(function() if setclipboard then setclipboard(invite) end end)
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = "Discord invite copied to clipboard!",
            SubContent = invite,
            Duration = 6
        })
    end
})

-- Default Tab + Notify
Window:SelectTab(1)
Fluent:Notify({
    Title = "MASTXR Hub",
    Content = "Musical Chairs Hub has been loaded!",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
