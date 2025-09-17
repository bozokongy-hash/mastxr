-- LocalScript: IEEF HUB Mini Menu with KeySystem v5
-- Place inside StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer

-- GUI Config
local DISCORD_LINK = "https://discord.gg/Q9caeDr2M8"
local VALID_KEY = "SWEB123" -- example key

-- States
local speedSafe = false
local speedRisk = false
local humanoid = nil

-- Remove existing GUI if any
if player.PlayerGui:FindFirstChild("IEEF_HUB") then
	player.PlayerGui.IEEF_HUB:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEF_HUB"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Notification Function
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
	Debris:AddItem(notif,2)
end

-- Key System Frame (same style as main menu)
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 180, 0, 120)
KeyFrame.Position = UDim2.new(0, 10, 1, -130)
KeyFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Visible = true
KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,10)

-- Key System Title
local KeyTitle = Instance.new("TextLabel")
KeyTitle.Text = "IEEF HUB"
KeyTitle.Size = UDim2.new(1,0,0,25)
KeyTitle.Position = UDim2.new(0,0,0,5)
KeyTitle.BackgroundTransparency = 1
KeyTitle.TextColor3 = Color3.fromRGB(255,255,255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextScaled = true
KeyTitle.Parent = KeyFrame

-- Key Input Box (smaller, centered)
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.7,0,0,25) -- smaller width and height
KeyBox.Position = UDim2.new(0.15,0,0,45)
KeyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Enter key here" -- placeholder text
KeyBox.ClearTextOnFocus = false
KeyBox.TextScaled = true
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextXAlignment = Enum.TextXAlignment.Center
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,6)

-- Check Key Button (green)
local CheckBtn = Instance.new("TextButton")
CheckBtn.Size = UDim2.new(0.45,0,0,30) -- slightly larger
CheckBtn.Position = UDim2.new(0.03,0,0,85) -- closer to left
CheckBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
CheckBtn.TextColor3 = Color3.fromRGB(255,255,255)
CheckBtn.Text = "Check Key"
CheckBtn.TextScaled = true
CheckBtn.Font = Enum.Font.Gotham
CheckBtn.Parent = KeyFrame
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0,6)

-- Discord Button (red)
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.45,0,0,30) -- slightly larger
DiscordBtn.Position = UDim2.new(0.52,0,0,85) -- closer to right
DiscordBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
DiscordBtn.TextColor3 = Color3.fromRGB(255,255,255)
DiscordBtn.Text = "Discord"
DiscordBtn.TextScaled = true
DiscordBtn.Font = Enum.Font.Gotham
DiscordBtn.Parent = KeyFrame
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0,6)

-- Discord Button Function
DiscordBtn.MouseButton1Click:Connect(function()
	setclipboard(DISCORD_LINK)
	ShowNotification("Discord link copied!", Color3.fromRGB(0,255,0))
end)

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 120)
MainFrame.Position = UDim2.new(0, 10, 1, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

-- Main Menu Title
local Title = Instance.new("TextLabel")
Title.Text = "IEEF HUB"
Title.Size = UDim2.new(1,0,0,25)
Title.Position = UDim2.new(0,0,0,5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = MainFrame

-- Safe Speed Button (Green)
local SafeBtn = Instance.new("TextButton")
SafeBtn.Size = UDim2.new(0.8,0,0,30)
SafeBtn.Position = UDim2.new(0.1,0,0,35)
SafeBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
SafeBtn.TextColor3 = Color3.fromRGB(255,255,255)
SafeBtn.Text = "Speed Boost (Safe)"
SafeBtn.Font = Enum.Font.Gotham
SafeBtn.TextScaled = true
SafeBtn.Parent = MainFrame
Instance.new("UICorner", SafeBtn).CornerRadius = UDim.new(0,6)

-- Risk Speed Button (Red)
local RiskBtn = Instance.new("TextButton")
RiskBtn.Size = UDim2.new(0.8,0,0,30)
RiskBtn.Position = UDim2.new(0.1,0,0,75)
RiskBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
RiskBtn.TextColor3 = Color3.fromRGB(255,255,255)
RiskBtn.Text = "Speed Boost (Risk)"
RiskBtn.Font = Enum.Font.Gotham
RiskBtn.TextScaled = true
RiskBtn.Parent = MainFrame
Instance.new("UICorner", RiskBtn).CornerRadius = UDim.new(0,6)

-- Update WalkSpeed
local function updateSpeed()
	if humanoid then
		if speedSafe then
			humanoid.WalkSpeed = 18
		elseif speedRisk then
			humanoid.WalkSpeed = 25
		else
			humanoid.WalkSpeed = 16
		end
	end
end

-- Speed Buttons
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

-- Toggle Menu with RightShift
UIS.InputBegan:Connect(function(input,gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- Character respawn handling
local function onCharacterAdded(char)
	humanoid = char:WaitForChild("Humanoid")
	updateSpeed()
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
	onCharacterAdded(player.Character)
end

-- Check Key Button Function
CheckBtn.MouseButton1Click:Connect(function()
	local keyEntered = KeyBox.Text
	if keyEntered == VALID_KEY then
		ShowNotification("Key Correct! Loading...", Color3.fromRGB(0,255,0))
		KeyFrame.Visible = false
		wait(3)
		MainFrame.Visible = true
	else
		ShowNotification("Invalid Key!", Color3.fromRGB(255,0,0))
	end
end)
