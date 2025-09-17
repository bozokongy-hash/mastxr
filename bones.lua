-- LocalScript: Place inside StarterPlayerScripts or StarterGui

--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

--// Config
local VALID_KEY = "ieef123" -- Example key; replace with your Discord key system
local DISCORD_LINK = "https://discord.gg/yourinvite" -- Replace with your Discord invite

--// GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEF_HUB"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Draggable main frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "IEEF HUB"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = MainFrame

-- Placeholder buttons
for i, name in ipairs({"Option 1", "Option 2", "Option 3"}) do
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0.8, 0, 0, 40)
	Btn.Position = UDim2.new(0.1, 0, 0, 40 + (i * 50))
	Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.Text = name
	Btn.Parent = MainFrame
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
end

-- Key System Frame
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 180)
KeyFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner", KeyFrame)
KeyCorner.CornerRadius = UDim.new(0, 10)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Text = "Enter Key"
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextScaled = true
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText = "Enter your key..."
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 30)
StatusText.Position = UDim2.new(0, 0, 0.7, 0)
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusText.Text = ""
StatusText.Parent = KeyFrame

-- Check Key button
local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0.35, 0, 0, 30)
CheckKeyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.Text = "Check Key"
CheckKeyBtn.Parent = KeyFrame
Instance.new("UICorner", CheckKeyBtn).CornerRadius = UDim.new(0, 8)

-- Discord button
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.35, 0, 0, 30)
DiscordBtn.Position = UDim2.new(0.55, 0, 0.55, 0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Text = "Discord"
DiscordBtn.Parent = KeyFrame
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

--// Functions
local function ShowNotification(msg, color)
	local Notification = Instance.new("TextLabel")
	Notification.Size = UDim2.new(0, 200, 0, 40)
	Notification.Position = UDim2.new(0.5, -100, 0.1, 0)
	Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Notification.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	Notification.Text = msg
	Notification.TextScaled = true
	Notification.Parent = ScreenGui
	Instance.new("UICorner", Notification).CornerRadius = UDim.new(0, 8)
	
	game:GetService("Debris"):AddItem(Notification, 2)
end

-- Check Key event
CheckKeyBtn.MouseButton1Click:Connect(function()
	if KeyBox.Text == VALID_KEY then
		StatusText.Text = ""
		KeyFrame.Visible = false
		ShowNotification("Loading IEEF HUB...", Color3.fromRGB(0, 255, 0))
		task.wait(1.5)
		MainFrame.Visible = true
	else
		StatusText.Text = "Invalid Key"
	end
end)

-- Discord button event
DiscordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DISCORD_LINK)
		ShowNotification("Discord link copied!", Color3.fromRGB(0, 255, 0))
	end
end)

-- Toggle menu with RightShift
UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
