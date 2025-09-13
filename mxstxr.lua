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

-- Tabs
local Tabs = {
    StealBrainrot = Window:AddTab({ Title = "Steal Brainrot", Icon = "brain" }),
    Rivals = Window:AddTab({ Title = "Rivals", Icon = "swords" }),
    Hypershot = Window:AddTab({ Title = "Hypershot", Icon = "crosshair" }), -- Added an icon
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Steal Brainrot Tab
Tabs.StealBrainrot:AddButton({
    Title = "Execute Script",
    Description = "Run Steal Brainrot",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_steal_brainrot_script"))()
    end
})

-- Rivals Tab
Tabs.Rivals:AddButton({
    Title = "Execute Script",
    Description = "Run Rivals Script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_rivals_script"))()
    end
})

-- Hypershot Tab
Tabs.Hypershot:AddButton({
    Title = "Execute Script",
    Description = "Run Hypershot Script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_hypershot_script"))()
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
