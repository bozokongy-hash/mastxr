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
    StealBrainrot = Window:AddTab({ Title = "Steal Brainrot", Icon = "cpu" }),
    Rivals        = Window:AddTab({ Title = "Rivals", Icon = "swords" }),
    Hypershot     = Window:AddTab({ Title = "Hypershot", Icon = "crosshair" }),
    NFLUniverse   = Window:AddTab({ Title = "NFL Universe", Icon = "shield" }),
    CustomScripts = Window:AddTab({ Title = "Custom Scripts", Icon = "code" }),
    UserScripts   = Window:AddTab({ Title = "User Scripts", Icon = "user" }),
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Helper function for "Coming Soon"
local function ComingSoon(title)
    return function()
        Fluent:Notify({Title="MASTXR Hub", Content=title.." is coming soon!", Duration=4})
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
Tabs.StealBrainrot:AddButton({
    Title = "Script 2",
    Description = "Coming Soon",
    Callback = ComingSoon("Steal Brainrot Script 2")
})

-- ===== Rivals Tab =====
Tabs.Rivals:AddButton({
    Title = "ZYPHERION Rivals Script",
    Description = "Main Script",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/blackowl1231/ZYPHERION/refs/heads/main/main.lua'))()
        Window:Destroy()
    end
})
Tabs.Rivals:AddButton({
    Title = "Script 2",
    Description = "Coming Soon",
    Callback = ComingSoon("Rivals Script 2")
})

-- ===== Hypershot Tab =====
Tabs.Hypershot:AddButton({
    Title = "Zephyr Hypershot Script",
    Description = "Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealAvrwm/Zephyr-V2/refs/heads/main/Hypershot.lua", true))()
        Window:Destroy()
    end
})
Tabs.Hypershot:AddButton({
    Title = "Script 2",
    Description = "Coming Soon",
    Callback = ComingSoon("Hypershot Script 2")
})

-- ===== NFL Universe Tab =====
Tabs.NFLUniverse:AddButton({
    Title = "Script 1",
    Description = "Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/your_nfl_script1"))()
        Window:Destroy()
    end
})
Tabs.NFLUniverse:AddButton({
    Title = "Script 2",
    Description = "Coming Soon",
    Callback = ComingSoon("NFL Universe Script 2")
})

-- ===== Custom Scripts Tab =====
local URLInput = Tabs.CustomScripts:AddInput({
    Title = "Script URL",
    Placeholder = "https://example.com/script.lua",
    Text = ""
})

Tabs.CustomScripts:AddButton({
    Title = "Run Script URL",
    Description = "Execute a Lua script from the URL above",
    Callback = function()
        local url = URLInput:GetText()
        if url and url ~= "" then
            pcall(function()
                loadstring(game:HttpGet(url, true))()
                Window:Destroy()
            end)
        else
            Fluent:Notify({Title="MASTXR Hub", Content="Please enter a valid script URL!", Duration=4})
        end
    end
})

local LuaInput = Tabs.CustomScripts:AddInput({
    Title = "Paste LUA Code",
    Placeholder = "-- paste your Lua code here",
    Text = "",
    MultiLine = true
})

Tabs.CustomScripts:AddButton({
    Title = "Run LUA Code",
    Description = "Execute the Lua code above",
    Callback = function()
        local code = LuaInput:GetText()
        if code and code ~= "" then
            pcall(function()
                loadstring(code)()
                Window:Destroy()
            end)
        else
            Fluent:Notify({Title="MASTXR Hub", Content="Please enter some Lua code!", Duration=4})
        end
    end
})

-- ===== User Scripts Tab =====
local UserScriptsFolder = "MASTXRHub/UserScripts"
SaveManager:SetFolder(UserScriptsFolder)
SaveManager:BuildConfigSection(Tabs.UserScripts)

local ScriptNameInput = Tabs.UserScripts:AddInput({
    Title = "Script Name",
    Placeholder = "Enter a name",
    Text = ""
})

local ScriptContentInput = Tabs.UserScripts:AddInput({
    Title = "Script URL or LUA",
    Placeholder = "Paste URL or Lua code",
    Text = "",
    MultiLine = true
})

Tabs.UserScripts:AddButton({
    Title = "Add Script",
    Description = "Save this script to the hub",
    Callback = function()
        local name = ScriptNameInput:GetText()
        local code = ScriptContentInput:GetText()
        if name ~= "" and code ~= "" then
            SaveManager:Set(name, code)
            SaveManager:SaveConfig("UserScripts")
            Tabs.UserScripts:AddButton({
                Title = name,
                Description = "Click to run",
                Callback = function()
                    pcall(function()
                        if code:sub(1,4) == "http" then
                            loadstring(game:HttpGet(code, true))()
                        else
                            loadstring(code)()
                        end
                        Window:Destroy()
                    end)
                end
            })
            Fluent:Notify({Title="MASTXR Hub", Content="Script added successfully!", Duration=4})
        else
            Fluent:Notify({Title="MASTXR Hub", Content="Please enter a name and a script!", Duration=4})
        end
    end
})

-- Load saved user scripts
for name, code in pairs(SaveManager:GetAll()) do
    Tabs.UserScripts:AddButton({
        Title = name,
        Description = "Click to run",
        Callback = function()
            pcall(function()
                if code:sub(1,4) == "http" then
                    loadstring(game:HttpGet(code, true))()
                else
                    loadstring(code)()
                end
                Window:Destroy()
            end)
        end
    })
end

-- ===== Settings Tab =====
Tabs.Settings:AddButton({
    Title = "Join our Discord",
    Icon = "discord",
    Description = "Click to copy the invite",
    Callback = function()
        local invite = "https://discord.gg/s2QBMdTF6G"
        pcall(function() if setclipboard then setclipboard(invite) end end)
        Fluent:Notify({Title="MASTXR Hub", Content="Discord invite copied to clipboard!", SubContent=invite, Duration=6})
    end
})

-- Now build settings sections AFTER adding buttons
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MASTXRHub")
SaveManager:SetFolder("MASTXRHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Default Tab + Notify
Window:SelectTab(1)
Fluent:Notify({Title="MASTXR Hub", Content="The script hub has been loaded!", Duration=8})

SaveManager:LoadAutoloadConfig()
