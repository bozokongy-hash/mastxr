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

-- Utility to find all seats/chairs anywhere in workspace
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

-- Auto Sit (teleports player to nearest free seat)
Tabs.MusicalChairs:AddButton({
    Title = "Auto Sit",
    Description = "Teleport to the nearest empty seat when music stops",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then
            Fluent:Notify({
                Title = "MASTXR Hub",
                Content = "Couldn't find HumanoidRootPart!",
                Duration = 5
            })
            return
        end

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
            -- Move you right over it
            hrp.CFrame = nearest.CFrame + Vector3.new(0, 2, 0)
            Fluent:Notify({
                Title = "MASTXR Hub",
                Content = "Teleported to nearest empty seat!",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "MASTXR Hub",
                Content = "No empty seats found!",
                Duration = 5
            })
        end
    end
})

-- ESP Chairs (highlight every seat)
Tabs.MusicalChairs:AddButton({
    Title = "ESP Chairs",
    Description = "Highlight all seats in view",
    Callback = function()
        local chairs = getAllChairs()
        for _, seat in ipairs(chairs) do
            -- Avoid duplicating highlight
            if not seat:FindFirstChild("ChairHighlight_MASTXR") then
                -- Some seats are not BasePart directly; check parent
                local partForHighlight = seat
                if not seat:IsA("BasePart") then
                    -- try find a part inside seat
                    partForHighlight = seat:FindFirstChildWhichIsA("BasePart") or seat
                end
                local hl = Instance.new("Highlight")
                hl.Name = "ChairHighlight_MASTXR"
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = partForHighlight
            end
        end
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = "ESP applied to all seats!",
            Duration = 6
        })
    end
})

-- Speed Boost (slider)
local player = game.Players.LocalPlayer
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

-- Placeholder future button
Tabs.MusicalChairs:AddButton({
    Title = "Feature 4",
    Description = "Coming Soon",
    Callback = ComingSoon("Musical Chairs Feature 4")
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
