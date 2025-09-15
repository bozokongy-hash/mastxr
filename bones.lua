-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Variables
local validKeys = {"ieef123", "musichub"} -- Add more valid keys here
local keyEntered = false

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEFHubGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = ScreenGui
mainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "IEEF Hub - Musical Chairs"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Key input box
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.7, -10, 0, 30)
keyBox.Position = UDim2.new(0, 10, 0, 60)
keyBox.PlaceholderText = "Enter your key"
keyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.ClearTextOnFocus = false
keyBox.Parent = mainFrame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 5)
keyCorner.Parent = keyBox

-- Check Key Button
local checkKeyButton = Instance.new("TextButton")
checkKeyButton.Size = UDim2.new(0.3, -10, 0, 30)
checkKeyButton.Position = UDim2.new(0.7, 0, 0, 60)
checkKeyButton.Text = "Check Key"
checkKeyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
checkKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
checkKeyButton.Font = Enum.Font.GothamBold
checkKeyButton.TextSize = 14
checkKeyButton.Parent = mainFrame

local checkCorner = Instance.new("UICorner")
checkCorner.CornerRadius = UDim.new(0, 5)
checkCorner.Parent = checkKeyButton

-- Discord Button
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(1, -20, 0, 30)
discordButton.Position = UDim2.new(0, 10, 0, 100)
discordButton.Text = "Discord"
discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.Font = Enum.Font.GothamBold
discordButton.TextSize = 14
discordButton.Parent = mainFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 5)
discordCorner.Parent = discordButton

-- Notification Label
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(1, -20, 0, 25)
notif.Position = UDim2.new(0, 10, 0, 140)
notif.BackgroundTransparency = 1
notif.Text = ""
notif.TextColor3 = Color3.fromRGB(0, 255, 0)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 14
notif.TextWrapped = true
notif.Parent = mainFrame

-- Functions
local function checkKey()
    if table.find(validKeys, keyBox.Text) then
        notif.Text = "Key valid! You can use the hub."
        keyEntered = true
    else
        notif.Text = "Invalid key!"
        keyEntered = false
    end
end

local function copyDiscordLink()
    local discordLink = "https://discord.gg/yourlink"
    setclipboard(discordLink)
    notif.Text = "Discord link copied!"
    notif.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- Events
checkKeyButton.MouseButton1Click:Connect(checkKey)
discordButton.MouseButton1Click:Connect(copyDiscordLink)

-- Optional: Close GUI with RightShift
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
