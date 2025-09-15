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

-- ===== Musical Chairs Tab =====
Tabs.MusicalChairs:AddButton({
    Title = "Auto Sit",
    Description = "Automatically grabs the nearest chair when the music stops",
    Callback = function()
        -- Example auto-sit feature
        local player = game.Players.LocalPlayer
        local chairs = workspace:WaitForChild("Chairs")

        local function sitInChair()
            local nearest, dist = nil, math.huge
            for _, chair in ipairs(chairs:GetChildren()) do
                if chair:IsA("Seat") and not chair.Occupant then
                    local d = (player.Character.HumanoidRootPart.Position - chair.Position).Magnitude
                    if d < dist then
                        nearest, dist = chair, d
                    end
                end
            end
            if nearest then
                player.Character:MoveTo(nearest.Position)
            end
        end

        sitInChair()
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = "Auto Sit activated! Will try to sit in nearest chair.",
            Duration = 6
        })
    end
})

Tabs.MusicalChairs:AddButton({
    Title = "ESP Chairs",
    Description = "Highlight all chairs so you never lose track",
    Callback = function()
        for _, chair in ipairs(workspace:WaitForChild("Chairs"):GetChildren()) do
            if chair:IsA("BasePart") and not chair:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight", chair)
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = "ESP applied to all chairs!",
            Duration = 6
        })
    end
})

Tabs.MusicalChairs:AddButton({
    Title = "Speed Boost",
    Description = "Move faster when music stops",
    Callback = function()
        local player = game.Players.LocalPlayer
        player.Character.Humanoid.WalkSpeed = 32
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = "Speed Boost activated!",
            Duration = 6
        })
    end
})

Tabs.MusicalChairs:AddButton({
    Title = "Script 4",
    Description = "Coming Soon",
    Callback = ComingSoon("Musical Chairs Script 4")
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
