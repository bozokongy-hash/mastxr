-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Main Window
local Window = Fluent:CreateWindow({
    Title = "MASTXR Hub " .. Fluent.Version,
    SubTitle = "by Top1 Sweb",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs (all with icons)
local Tabs = {
    StealBrainrot = Window:AddTab({ Title = "Steal Brainrot", Icon = "zap" }),     -- ⚡ zap icon
    Rivals        = Window:AddTab({ Title = "Rivals", Icon = "swords" }),         -- ⚔️ swords
    Hypershot     = Window:AddTab({ Title = "Hypershot", Icon = "crosshair" }),   -- 🎯 crosshair
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" })      -- ⚙️ gear
}

-- Steal Brainrot Tab (2 scripts)
Tabs.StealBrainrot:AddButton({
    Title = "Script 1",
    Description = "Steal Brainrot - Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_steal_brainrot_script1"))()
    end
})

Tabs.StealBrainrot:AddButton({
    Title = "Script 2",
    Description = "Steal Brainrot - Extra",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_steal_brainrot_script2"))()
    end
})

-- Rivals Tab (2 scripts)
Tabs.Rivals:AddButton({
    Title = "Script 1",
    Description = "Rivals - Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_rivals_script1"))()
    end
})

Tabs.Rivals:AddButton({
    Title = "Script 2",
    Description = "Rivals - Extra",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_rivals_script2"))()
    end
})

-- Hypershot Tab (2 scripts)
Tabs.Hypershot:AddButton({
    Title = "Script 1",
    Description = "Hypershot - Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_hypershot_script1"))()
    end
})

Tabs.Hypershot:AddButton({
    Title = "Script 2",
    Description = "Hypershot - Extra",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_hypershot_script2"))()
    end
})

-- Settings (Save + Configs)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MASTXRHub")
SaveManager:SetFolder("MASTXRHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Default Tab + Notify
Window:SelectTab(1)
Fluent:Notify({
    Title = "MASTXR Hub",
    Content = "The script hub has been loaded!",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
