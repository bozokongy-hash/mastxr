-- Load MASTXR (Fluent rebrand)
local MASTXR = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create main window
local Window = MASTXR:CreateWindow({
    Title = "MASTXR Script Hub",
    SubTitle = "by Sweb",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ===== Tabs =====
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Brainrot = Window:AddTab({ Title = "Steal a Brainrot", Icon = "cpu" }),
    RivalsW = Window:AddTab({ Title = "RivalsW", Icon = "code" }),
    Hypershot = Window:AddTab({ Title = "Hypershot", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- ===== Main Tab =====
Tabs.Main:AddParagraph({
    Title = "Welcome to MASTXR",
    Content = "Select a script tab to load your scripts."
})

-- Helper function to add script buttons
local function AddScriptButton(tab, name, url)
    tab:AddButton({
        Title = name,
        Description = "Load " .. name,
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                MASTXR:Notify({
                    Title = "MASTXR",
                    Content = "Failed to load script: " .. name,
                    SubContent = err,
                    Duration = 5
                })
            end
        end
    })
end

-- ===== Brainrot Tab =====
-- Replace URLs with actual script URLs
AddScriptButton(Tabs.Brainrot, "Brainrot Script 1", "https://raw.githubusercontent.com/YourRepo/Brainrot1.lua")
AddScriptButton(Tabs.Brainrot, "Brainrot Script 2", "https://raw.githubusercontent.com/YourRepo/Brainrot2.lua")

-- ===== RivalsW Tab =====
AddScriptButton(Tabs.RivalsW, "RivalsW Script 1", "https://raw.githubusercontent.com/YourRepo/RivalsW1.lua")
AddScriptButton(Tabs.RivalsW, "RivalsW Script 2", "https://raw.githubusercontent.com/YourRepo/RivalsW2.lua")

-- ===== Hypershot Tab =====
AddScriptButton(Tabs.Hypershot, "Hypershot Script 1", "https://raw.githubusercontent.com/YourRepo/Hypershot1.lua")
AddScriptButton(Tabs.Hypershot, "Hypershot Script 2", "https://raw.githubusercontent.com/YourRepo/Hypershot2.lua")

-- ===== Settings Tab =====
SaveManager:SetLibrary(MASTXR)
InterfaceManager:SetLibrary(MASTXR)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("MASTXRHub/configs")
InterfaceManager:SetFolder("MASTXRHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Open first tab by default
Window:SelectTab(1)

-- Notification
MASTXR:Notify({
    Title = "MASTXR",
    Content = "Script hub loaded successfully!",
    Duration = 5
})
