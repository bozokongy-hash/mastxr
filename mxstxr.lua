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

-- Tabs (all with icons)
local Tabs = {
    StealBrainrot = Window:AddTab({ Title = "Steal Brainrot", Icon = "skull" }),   -- 💀 Skull
    Rivals        = Window:AddTab({ Title = "Rivals", Icon = "swords" }),         -- ⚔️ Swords
    Hypershot     = Window:AddTab({ Title = "Hypershot", Icon = "crosshair" }),   -- 🎯 Crosshair
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" })      -- ⚙️ Gear
}

-- Placeholders (we’ll add scripts after)
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
