-- LocalScript: IEEF HUB Mini Menu
-- Place inside StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Config
local DISCORD_LINK = "https://discord.gg/Q9caeDr2M8"

-- States
local speedSafe = false
local speedRisk = false

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEF_HUB"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 160, 0, 80)
MainFrame.Position = UDim2.new(0, 10, 1, -90) -- bottom-left corner
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "IEEF HUB"
Title.Size = UDim2.new(1,0,0,20)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,255,128)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = MainFrame

-- Safe Speed Button (Green)
local SafeBtn = Instance.new("TextButton")
SafeBtn.Size = UDim2.new(0.8,0,0,25)
SafeBtn.Position = UDim2.new(0.1,0,0,25)
SafeBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
SafeBtn.TextColor3 = Color3.fromRGB(255,255,255)
SafeBtn.Text = "Speed Boost (Safe)"
SafeBtn.Font = Enum.Font.Gotham
SafeBtn.TextScaled = true
SafeBtn.Parent = MainFrame
Instance.new("UICorner", SafeBtn).CornerRadius = UDim.new(0,6)

-- Risk Speed Button (Red)
local RiskBtn = Instance.new("TextButton")
RiskBtn.Size = UDim2.new(0.8,0,0,25)
RiskBtn.Position = UDim2.new(0.1,0,0,55)
RiskBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
RiskBtn.TextColor3 = Color3.fromRGB(255,255,255)
RiskBtn.Text = "Speed Boost (Risk)"
RiskBtn.Font = Enum.Font.Gotham
RiskBtn.TextScaled = true
RiskBtn.Parent = MainFrame
Instance.new("UICorner", RiskBtn).CornerRadius = UDim.new(0,6)

-- Notification
local function ShowNotification(msg,color)
	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0,180,0,30)
	notif.Position = UDim2.new(0,10,1,-130)
	notif.BackgroundColor3 = Color3.fromRGB(40,40,40)
	notif.TextColor3 = color or Color3.fromRGB(255,255,255)
	notif.TextScaled = true
	notif.Font = Enum.Font.Gotham
	notif.Text = msg
	notif.Parent = ScreenGui
	Instance.new("UICorner", notif).CornerRadius = UDim.new(0,6)
	game:GetService("Debris"):AddItem(notif,2)
end

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

-- Toggle Menu with RightShift
UIS.InputBegan:Connect(function(input,gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
