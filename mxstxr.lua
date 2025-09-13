--[[ 
    FLUENT SCRIPT HUB - Multi-Script Loader with Key System
    Using Fluent UI for key input
--]]

local allowedKeys = {"sweb123"} -- Add more keys here

-- Load Fluent GUI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create the main window
local Window = Fluent:CreateWindow({
    Title = "Sweb Hub",
    SubTitle = "Multi-Script Loader",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Key = Window:AddTab({Title = "Enter Key", Icon = ""}),
    Home = Window:AddTab({Title = "Home", Icon = ""}),
    Scripts = Window:AddTab({Title = "Scripts", Icon = ""}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

-- Lock all tabs except Key
Tabs.Home:SetDisabled(true)
Tabs.Scripts:SetDisabled(true)
Tabs.Settings:SetDisabled(true)
Window:SelectTab(Tabs.Key) -- Force user to enter key first

-- =========================
-- Key System using Fluent
-- =========================
local KeyInputBox = Tabs.Key:AddInput("HubKey", {
    Title = "Enter Hub Key",
    Placeholder = "Type key here...",
    Finished = true, -- Only calls callback when user presses Enter
    Callback = function(Value)
        local success = false
        for _, k in pairs(allowedKeys) do
            if Value == k then
                success = true
                break
            end
        end
        if success then
            -- Unlock all tabs
            Tabs.Home:SetDisabled(false)
            Tabs.Scripts:SetDisabled(false)
            Tabs.Settings:SetDisabled(false)
            Fluent:Notify({Title = "Access Granted", Content = "Welcome to Sweb Hub!", Duration = 5})
            Window:SelectTab(Tabs.Home) -- Switch to Home automatically
        else
            Fluent:Notify({Title = "Invalid Key", Content = "Please try again!", Duration = 5})
        end
    end
})

-- =========================
-- Home Tab
-- =========================
Tabs.Home:AddParagraph({
    Title = "Sweb Hub",
    Content = "Created by Top1 Sweb\nDiscord: @4503\nUse at your own risk!"
})

-- =========================
-- Scripts Tab
-- =========================
local scripts = {
    {Name = "Script 1", URL = "https://pastebin.com/raw/XXXXXX"},
    {Name = "Script 2", URL = "https://pastebin.com/raw/YYYYYY"},
    {Name = "Script 3", URL = "https://pastebin.com/raw/ZZZZZZ"}
}

for _, scriptInfo in pairs(scripts) do
    Tabs.Scripts:AddButton({
        Title = scriptInfo.Name,
        Description = "Load " .. scriptInfo.Name,
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(scriptInfo.URL))()
            end)
            if not success then
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to load " .. scriptInfo.Name,
                    SubContent = err,
                    Duration = 5
                })
            end
        end
    })
end

-- =========================
-- Settings Tab (Fluent Addons)
-- =========================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(Tabs.Key) -- Start with key input tab
