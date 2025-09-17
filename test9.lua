-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Key and Discord link
local REQUIRED_KEY = "sweb123"
local discordLink = "https://discord.gg/s2QBMdTF6G"

-- === Notify Discord on execute ===
pcall(function() if setclipboard then setclipboard(discordLink) end end)
Fluent:Notify({
    Title = "MASTXR Hub",
    Content = "Discord link copied (KEY)",
    SubContent = discordLink,
    Duration = 6
})

-- === Main GUI ===
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
    StealBrainrot = Window:AddTab({ Title = "Steal Brainrot", Icon = "cpu" }),
    Rivals        = Window:AddTab({ Title = "Rivals", Icon = "swords" }),
    Hypershot     = Window:AddTab({ Title = "Hypershot", Icon = "crosshair" }),
    MusicalChairs = Window:AddTab({ Title = "Musical Chairs", Icon = "shield" }),
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Initially disable all tabs
for _, tab in pairs(Tabs) do
    tab:SetDisabled(true)
end

-- ===== Fluent-style Key GUI =====
local KeyWindow = Fluent:CreateWindow({
    Title = "Enter Key",
    SubTitle = "Unlock MASTXR Hub",
    Size = UDim2.fromOffset(400, 180),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- optional
})

-- Add Section
local Section = KeyWindow:AddSection({ Title = "Key Verification" })

local KeyBoxValue = ""

-- Textbox for key
Section:AddTextbox({
    Title = "Enter Key",
    Default = "",
    Placeholder = "Enter your key here...",
    Callback = function(text)
        KeyBoxValue = text
    end
})

-- Submit button
Section:AddButton({
    Title = "Submit Key",
    Callback = function()
        if KeyBoxValue == REQUIRED_KEY then
            -- Copy Discord link and notify
            pcall(function() if setclipboard then setclipboard(discordLink) end end)
            Fluent:Notify({
                Title = "MASTXR Hub",
                Content = "Discord link copied (KEY)",
                SubContent = discordLink,
                Duration = 6
            })
            -- Unlock all tabs
            for _, tab in pairs(Tabs) do
                tab:SetDisabled(false)
            end
            -- Destroy KeyWindow
            KeyWindow:Destroy()
            -- Select first tab
            Window:SelectTab(1)
        else
            Fluent:Notify({
                Title = "MASTXR Hub",
                Content = "Invalid Key!",
                Duration = 4
            })
        end
    end
})

-- ===== Helper for "Coming Soon" =====
local function ComingSoon(title)
    return function()
        Fluent:Notify({ Title = "MASTXR Hub", Content = title .. " is coming soon!", Duration = 4 })
    end
end

-- ===== Steal Brainrot Tab =====
Tabs.StealBrainrot:AddButton({
    Title = "Steal A Brainrot Script",
    Description = "Main Script",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/KaspikScriptsRb/steal-a-brainrot/refs/heads/main/.lua'))()
        Window:Destroy()
    end
})
Tabs.StealBrainrot:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Steal Brainrot Script 2") })

-- ===== Rivals Tab =====
Tabs.Rivals:AddButton({
    Title = "ZYPHERION Rivals Script",
    Description = "Rivals - Main Script",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/blackowl1231/ZYPHERION/refs/heads/main/main.lua'))()
        Window:Destroy()
    end
})
Tabs.Rivals:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Rivals Script 2") })

-- ===== Hypershot Tab =====
Tabs.Hypershot:AddButton({
    Title = "Zephyr Hypershot Script",
    Description = "Hypershot - Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealAvrwm/Zephyr-V2/refs/heads/main/Hypershot.lua", true))()
        Window:Destroy()
    end
})
Tabs.Hypershot:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Hypershot Script 2") })

-- ===== Musical Chairs Tab =====
Tabs.MusicalChairs:AddButton({
    Title = "Ieef Script",
    Description = "Musical Chairs - Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bozokongy-hash/mastxr/refs/heads/main/ieefcreation.lua"))()
        Window:Destroy()
    end
})
Tabs.MusicalChairs:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Musical Chairs Script 2") })

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
        pcall(function() if setclipboard then setclipboard(discordLink) end end)
        Fluent:Notify({ Title = "MASTXR Hub", Content = "Discord invite copied to clipboard!", SubContent = discordLink, Duration = 6 })
    end
})

Fluent:Notify({ Title = "MASTXR Hub", Content = "The script hub has been loaded!", Duration = 8 })
SaveManager:LoadAutoloadConfig()
