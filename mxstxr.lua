--[[ 
    FLUENT SCRIPT HUB - Multi-Script Loader with Key System
    WARNING: Use at your own risk
--]]

-- =========================
-- 🔑 Key System
-- =========================
local allowedKeys = {"sweb123"} -- Add more keys if needed
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Simple key prompt using a ScreenGui
local function requestKey()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeyPromptGui"
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 150)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Text = "Enter Key"
    Title.Size = UDim2.new(1,0,0,50)
    Title.BackgroundTransparency = 1
    Title.TextScaled = true
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = Frame

    local TextBox = Instance.new("TextBox")
    TextBox.PlaceholderText = "Key here..."
    TextBox.Size = UDim2.new(1, -20, 0, 50)
    TextBox.Position = UDim2.new(0,10,0,60)
    TextBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    TextBox.TextColor3 = Color3.fromRGB(255,255,255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextScaled = true
    TextBox.Parent = Frame

    local Submit = Instance.new("TextButton")
    Submit.Text = "Submit"
    Submit.Size = UDim2.new(0, 100, 0, 30)
    Submit.Position = UDim2.new(0.5, -50, 1, -40)
    Submit.BackgroundColor3 = Color3.fromRGB(255,0,0)
    Submit.TextColor3 = Color3.fromRGB(255,255,255)
    Submit.Font = Enum.Font.SourceSansBold
    Submit.TextScaled = true
    Submit.Parent = Frame

    local keyValid = false
    local connection
    connection = Submit.MouseButton1Click:Connect(function()
        local inputKey = TextBox.Text
        for _, validKey in pairs(allowedKeys) do
            if inputKey == validKey then
                keyValid = true
                break
            end
        end
        if keyValid then
            ScreenGui:Destroy()
        else
            TextBox.Text = ""
            TextBox.PlaceholderText = "Invalid Key!"
        end
    end)

    repeat wait() until keyValid
end

requestKey() -- run key system before loading hub

-- =========================
-- 🔧 Load Fluent GUI
-- =========================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

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
    Home = Window:AddTab({ Title = "Home", Icon = "" }),
    Scripts = Window:AddTab({ Title = "Scripts", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- =========================
-- 🏠 Home Tab
-- =========================
Tabs.Home:AddParagraph({
    Title = "Sweb Hub",
    Content = "Created by Top1 Sweb\nDiscord: @4503\nUse at your own risk!"
})

-- =========================
-- 📂 Scripts Tab
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

Window:SelectTab(1) -- Open Home tab by default

Fluent:Notify({
    Title = "Sweb Hub",
    Content = "The hub has been loaded successfully!",
    Duration = 8
})
