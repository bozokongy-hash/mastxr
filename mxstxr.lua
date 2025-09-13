--[[ 
    SCRIPT HUB - Multi-Script Loader with Key System
    WARNING: Use at your own risk
--]]

-- =========================
-- 🔑 Key System
-- =========================
local allowedKeys = {"sweb123"} -- add more keys if needed
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("StarterGui")

-- Simple GUI input for key (using TextBox)
local function requestKey()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeyPromptGui"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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
-- 🔧 Load RedzLib GUI
-- =========================
local redzlib = loadstring(game:HttpGet("https://gist.githubusercontent.com/MjContiga1/54c07e52fc2aab8873b68d91a71d11c6/raw/fb4f1d6a7c89465f3b39bc00eeff09af24b88f20/Redz%2520hub.lua"))()

-- Create main window
local Window = redzlib:MakeWindow({
    Title = "Sweb Hub",
    SubTitle = "Multi-Script Loader",
    SaveFolder = "SwebHub"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://139438145143663", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- =========================
-- 🏠 Home Tab
-- =========================
local HomeTab = Window:MakeTab({"Home", "rbxassetid://7733960981"})
Window:SelectTab(HomeTab)

local SectionHome = HomeTab:AddSection({"Credits"})
HomeTab:AddParagraph({"Sweb Hub", "Created by Top1 Sweb\nDiscord: @4503\nUse at your own risk!"})

-- =========================
-- 📂 Scripts Tab
-- =========================
local ScriptsTab = Window:MakeTab({"Scripts", "rbxassetid://7743875962"})
Window:SelectTab(ScriptsTab)

local SectionScripts = ScriptsTab:AddSection({"Available Scripts"})

-- Example Script Buttons (replace URLs with your actual scripts)
ScriptsTab:AddButton({"Script 1", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/XXXXXX"))()
end})

ScriptsTab:AddButton({"Script 2", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/YYYYYY"))()
end})

ScriptsTab:AddButton({"Script 3", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ZZZZZZ"))()
end})

ScriptsTab:AddButton({"Script 4", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/AAAAAA"))()
end})

ScriptsTab:AddButton({"Script 5", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/BBBBBB"))()
end})

-- =========================
-- ✅ Optional: Dialog Example
-- =========================
ScriptsTab:AddButton({"Test Dialog", function()
    Window:Dialog({
        Title = "Test",
        Text = "This is a test dialog!",
        Options = {{"OK", function() end}}
    })
end})

-- =========================
-- HUB READY
-- =========================
print("Sweb Hub Loaded Successfully!")
