-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Main Window
local Window = Fluent:CreateWindow({
    Title = "MASTXR Hub " .. Fluent.Version,
    SubTitle = "by Sweb @4503",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs (with icons)
local Tabs = {
    StealBrainrot = Window:AddTab({ Title = "Steal Brainrot", Icon = "brain" }),   -- brain icon
    Rivals        = Window:AddTab({ Title = "Rivals", Icon = "swords" }),         -- crossed swords icon
    Hypershot     = Window:AddTab({ Title = "Hypershot", Icon = "crosshair" }),   -- crosshair icon
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" })      -- gear icon
}

-- Placeholders (empty for now, we’ll add scripts later)
Tabs.StealBrainrot:AddParagraph({
    Title = "Coming Soon",
    Content = "Steal Brainrot scripts will be added here."
})

Tabs.Rivals:AddParagraph({
    Title = "Coming Soon",
    Content = "Rivals scripts will be added here."
})

Tabs.Hypershot:AddParagraph({
    Title = "Coming Soon",
    Content = "Hypershot scripts will be added here."
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
