-- LocalScript: IEEF HUB with Key System + Mini Menu
-- Place inside StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Config
local VALID_KEY = "ieef123" -- change as you like
local DISCORD_LINK = "https://discord.gg/Q9caeDr2M8"

-- States
local speedSafe = false
local speedRisk = false

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEF_HUB"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

----------------------
-- KEY GUI
----------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 180)
KeyFrame.Position = UDim2.new(0.35,0,0.35,0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Text = "Enter Key"
KeyTitle.Size = UDim2.new(1,0,0,40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.TextColor3 = Color3.fromRGB(0,255,128)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextScaled = true
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8,0,0,35)
KeyBox.Position = UDim2.new(0.1,0,0.35,0)
KeyBox.PlaceholderText = "Enter your key..."
KeyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextScaled = true
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,10)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1,0,0,30)
StatusText.Position = UDim2.new(0,0,0.7,0)
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.fromRGB(255,50,50)
StatusText.Font = Enum.Font.Gotham
StatusText.TextScaled = true
StatusText.Text = ""
StatusText.Parent = KeyFrame

-- Check Key Button
local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0.45,0,0,30)
CheckKeyBtn.Position = UDim2.new(0.05,0,0.55,0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
CheckKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
CheckKeyBtn.Text = "Check Key"
CheckKeyBtn.Font = Enum.Font.Gotham
CheckKeyBtn.TextScaled = true
CheckKeyBtn.Parent = KeyFrame
Instance.new("UICorner", CheckKeyBtn).CornerRadius = UDim.new(0,8)

-- Discord Button
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.45,0,0,30)
DiscordBtn.Position = UDim2.new(0.5,0,0.55,0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
DiscordBtn.TextColor3 = Color3.fromRGB(255,255,255)
DiscordBtn.Text = "Discord"
DiscordBtn.Font = Enum.Font.Gotham
DiscordBtn.TextScaled = true
DiscordBtn.Parent = KeyFrame
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0,8)

-- Notifications
local function ShowNotification(msg,color)
	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0,180,0,30)
	notif.Position = UDim2.new(0,10,1,-170)
	notif.BackgroundColor3 = Color3.fromRGB(40,40,40)
	notif.TextColor3 = color or Color3.fromRGB(255,255,255)
	notif.TextScaled = true
	notif.Font = Enum.Font.Gotham
	notif.Text = msg
	notif.Parent = ScreenGui
	Instance.new("UICorner", notif).CornerRadius = UDim.new(0,6)
	game:GetService("Debris"):AddItem(notif,2)
end

-- Key check logic
CheckKeyBtn.MouseButton1Click:Connect(function()
	if KeyBox.Text == VALID_KEY then
		StatusText.Text = ""
		KeyFrame.Visible = false
		ShowNotification("Key accepted! Loading IEEF HUB...", Color3.fromRGB(0,255,128))
		task.wait(1)
		MiniMenu.Visible = true
	else
		StatusText.Text = "Invalid Key"
	end
end)

-- Discord copy
DiscordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DISCORD_LINK)
		ShowNotification("Discord link copied!", Color3.fromRGB(0,255,0))
	end
end)

----------------------
-- MINI MENU
----------------------
local MiniMenu = Instance.new("Frame")
MiniMenu.Size = UDim2.new(0, 200, 0, 130)
MiniMenu.Position = UDim2.new(0,10,1,-150)
MiniMenu.BackgroundColor3 = Color3.fromRGB(0,0,0)
MiniMenu.BorderSizePixel = 0
MiniMenu.Active = true
MiniMenu.Visible = false
MiniMenu.Parent = ScreenGui
Instance.new("UICorner", MiniMenu).CornerRadius = UDim.new(0,10)

local TitleMini = Instance.new("TextLabel")
TitleMini.Text = "IEEF HUB"
TitleMini.Size = UDim2.new(1,0,0,25)
TitleMini.Position = UDim2.new(0,0,0,5)
TitleMini.BackgroundTransparency = 1
TitleMini.TextColor3 = Color3.fromRGB(255,255,255)
TitleMini.Font = Enum.Font.GothamBold
TitleMini.TextScaled = true
TitleMini.Parent = MiniMenu

-- Safe Button
local SafeBtn = Instance.new("TextButton")
SafeBtn.Size = UDim2.new(0.8,0,0,30)
SafeBtn.Position = UDim2.new(0.1,0,0,35)
SafeBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
SafeBtn.TextColor3 = Color3.fromRGB(255,255,255)
SafeBtn.Text = "Speed Boost (Safe)"
SafeBtn.Font = Enum.Font.Gotham
SafeBtn.TextScaled = true
SafeBtn.Parent = MiniMenu
Instance.new("UICorner", SafeBtn).CornerRadius = UDim.new(0,6)

-- Risk Button
local RiskBtn = Instance.new("TextButton")
RiskBtn.Size = UDim2.new(0.8,0,0,30)
RiskBtn.Position = UDim2.new(0.1,0,0,75)
RiskBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
RiskBtn.TextColor3 = Color3.fromRGB(255,255,255)
RiskBtn.Text = "Speed Boost (Risk)"
RiskBtn.Font = Enum.Font.Gotham
RiskBtn.TextScaled = true
RiskBtn.Parent = MiniMenu
Instance.new("UICorner", RiskBtn).CornerRadius = UDim.new(0,6)

-- Toggle Functions
local function updateSpeed()
	if speedSafe then
		humanoid.WalkSpeed = 18
	elseif speedRisk then
		humanoid.WalkSpeed = 25
	else
		humanoid.WalkSpeed = 16
	end
end

SafeBtn.MouseButton1Click:Connect(function()
	speedSafe = not speedSafe
	if speedSafe then
		speedRisk = false
		ShowNotification("Safe Speed ON", Color3.fromRGB(0,255,0))
	else
		ShowNotification("Safe Speed OFF", Color3.fromRGB(255,255,255))
	end
	updateSpeed()
end)

RiskBtn.MouseButton1Click:Connect(function()
	speedRisk = not speedRisk
	if speedRisk then
		speedSafe = false
		ShowNotification("Risk Speed ON", Color3.fromRGB(200,0,0))
	else
		ShowNotification("Risk Speed OFF", Color3.fromRGB(255,255,255))
	end
	updateSpeed()
end)

-- Toggle mini menu with RightShift
UIS.InputBegan:Connect(function(input,gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		MiniMenu.Visible = not MiniMenu.Visible
	end
end)
