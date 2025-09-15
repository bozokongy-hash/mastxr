-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "Custom Menu",
    LoadingTitle = "Initializing GUI...",
    LoadingSubtitle = "by Sweb",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Leave nil to use default
       FileName = "CustomMenuConfig"
    },
    Discord = {
       Enabled = false,
       Invite = "YourInvite", -- Example: "abc123"
       RememberJoins = true
    },
    KeySystem = false, -- Set to true if you want key system
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

-- Example Tab 1
local MainTab = Window:CreateTab("Home", 4483362458) -- Icon can be AssetID

-- Example Section in Tab
local Section1 = MainTab:CreateSection("Welcome Section")

-- Example Button
MainTab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

-- Example Toggle
MainTab:CreateToggle({
    Name = "Example Toggle",
    CurrentValue = false,
    Flag = "ExampleToggle",
    Callback = function(value)
        print("Toggle state:", value)
    end
})

-- Example Slider
MainTab:CreateSlider({
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

-- Example Dropdown
MainTab:CreateDropdown({
    Name = "Example Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = "Option 1",
    Flag = "ExampleDropdown",
    Callback = function(option)
        print("Selected option:", option)
    end
})

-- Another Tab
local ScriptsTab = Window:CreateTab("Scripts", 6023426926)

ScriptsTab:CreateSection("Script Loader")
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

