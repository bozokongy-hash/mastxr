-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Rayfield/main/source'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "Custom Menu",
    LoadingTitle = "Initializing GUI...",
    LoadingSubtitle = "by Sweb",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Uses default folder
       FileName = "CustomMenuConfig"
    },
    Discord = {
       Enabled = false,
       Invite = "", -- Optional Discord invite
       RememberJoins = true
    },
    KeySystem = false, -- Change to true if you want a key system
    KeySettings = {
       Title = "Key System",
       Subtitle = "Enter your key",
       Note = "Contact Sweb for a key",
       FileName = "KeyFile",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = ""
    }
})

-- =========================
-- HOME TAB
-- =========================
local HomeTab = Window:CreateTab("Home", 4483362458) -- Icon asset ID
HomeTab:CreateSection("Welcome Section")

-- Button example
HomeTab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

-- Toggle example
HomeTab:CreateToggle({
    Name = "Example Toggle",
    CurrentValue = false,
    Flag = "ExampleToggle",
    Callback = function(value)
        print("Toggle state:", value)
    end
})

-- Slider example
HomeTab:CreateSlider({
    Name = "Example Slider",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "ExampleSlider",
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- Dropdown example
HomeTab:CreateDropdown({
    Name = "Example Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = "Option 1",
    Flag = "ExampleDropdown",
    Callback = function(option)
        print("Selected option:", option)
    end
})

-- =========================
-- SCRIPTS TAB
-- =========================
local ScriptsTab = Window:CreateTab("Scripts", 6023426926)
ScriptsTab:CreateSection("Script Loader")

-- Input for raw Lua script URL
ScriptsTab:CreateInput({
    Name = "Load Script URL",
    PlaceholderText = "Paste raw .lua URL here",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        if text ~= "" then
            loadstring(game:HttpGet(text))()
        end
    end
})

-- =========================
-- SETTINGS TAB (Optional)
-- =========================
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("UI Settings")

-- Example toggle for theme
SettingsTab:CreateToggle({
    Name = "Enable Dark Mode",
    CurrentValue = true,
    Flag = "DarkMode",
    Callback = function(value)
        print("Dark Mode:", value)
        -- You can later connect this to your GUI theme
    end
})

-- Example slider for GUI transparency
SettingsTab:CreateSlider({
    Name = "GUI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "GUITransparency",
    Callback = function(value)
        print("Transparency set to:", value)
        -- Connect this to GUI transparency later
    end
})
