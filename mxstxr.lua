--[[ WARNING: Heads up! Use at your own risk! ]] 

local redzlib = loadstring(game:HttpGet("https://gist.githubusercontent.com/MjContiga1/54c07e52fc2aab8873b68d91a71d11c6/raw/fb4f1d6a7c89465f3b39bc00eeff09af24b88f20/Redz%2520hub.lua"))()

-- Create main hub window
local Window = redzlib:MakeWindow({ 
    Title = "Sweb Script Hub", 
    SubTitle = "Multi-Script Hub", 
    SaveFolder = "SwebScriptHub" 
})

Window:AddMinimizeButton({ 
    Button = { Image = "rbxassetid://139438145143663", BackgroundTransparency = 0 }, 
    Corner = { CornerRadius = UDim.new(35, 1) } 
})

-- ===========================
-- EXAMPLE TAB 1
-- ===========================
local Tab1 = Window:MakeTab({"Scripts 1", "rbxassetid://7733960981"})
Tab1:AddSection({"Popular Scripts"})

Tab1:AddButton({"Load Script A", function()
    loadstring(game:HttpGet("YOUR_SCRIPT_A_URL_HERE"))()
end})

Tab1:AddButton({"Load Script B", function()
    loadstring(game:HttpGet("YOUR_SCRIPT_B_URL_HERE"))()
end})

Tab1:AddDropdown({
    Name = "Multi-Script Loader",
    Options = {"Script X", "Script Y", "Script Z"},
    Default = "Script X",
    MultiSelect = true,
    Callback = function(selected)
        for _, scriptName in ipairs(selected) do
            if scriptName == "Script X" then
                loadstring(game:HttpGet("YOUR_SCRIPT_X_URL"))()
            elseif scriptName == "Script Y" then
                loadstring(game:HttpGet("YOUR_SCRIPT_Y_URL"))()
            elseif scriptName == "Script Z" then
                loadstring(game:HttpGet("YOUR_SCRIPT_Z_URL"))()
            end
        end
    end
})

-- ===========================
-- EXAMPLE TAB 2
-- ===========================
local Tab2 = Window:MakeTab({"Scripts 2", "rbxassetid://7743875962"})
Tab2:AddSection({"Other Scripts"})

Tab2:AddButton({"Load Script C", function()
    loadstring(game:HttpGet("YOUR_SCRIPT_C_URL_HERE"))()
end})

Tab2:AddButton({"Load Script D", function()
    loadstring(game:HttpGet("YOUR_SCRIPT_D_URL_HERE"))()
end})

-- ===========================
-- OPTION: Add global multi-select or custom scripts dynamically
-- ===========================
local allScripts = {
    ["Script 1"] = "URL_1",
    ["Script 2"] = "URL_2",
    ["Script 3"] = "URL_3"
}

local MultiTab = Window:MakeTab({"Multi Loader", "rbxassetid://7733960981"})
MultiTab:AddDropdown({
    Name = "Select Scripts",
    Options = {"Script 1", "Script 2", "Script 3"},
    MultiSelect = true,
    Callback = function(selected)
        for _, name in ipairs(selected) do
            if allScripts[name] then
                loadstring(game:HttpGet(allScripts[name]))()
            end
        end
    end
})

MultiTab:AddButton({"Load All Scripts", function()
    for _, url in pairs(allScripts) do
        loadstring(game:HttpGet(url))()
    end
end})
