-- LocalScript: IEEF HUB v2
-- Place in StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Config
local VALID_KEY = "ieef123"
local DISCORD_LINK = "https://discord.gg/Q9caeDr2M8"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEF_HUB"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 220)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Frame drag logic
local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		-- Only allow drag if not clicking slider handle
		if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			local mouse = UIS:GetMouseLocation()
			local sliderPos = SliderFrame.AbsolutePosition
			local sliderSize = SliderFrame.AbsoluteSize
			if mouse.X < sliderPos.X or mouse.X > sliderPos.X + sliderSize.X or
			   mouse.Y < sliderPos.Y or mouse.Y > sliderPos.Y + sliderSize.Y then
				dragging = true
				dragStart = input.Position
				startPos = MainFrame.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "IEEF HUB"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = MainFrame

-- Speed Boost label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "Speed Boost: 16"
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 28)
SpeedLabel.Position = UDim2.new(0.1, 0, 0, 60)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextScaled = true
SpeedLabel.Parent = MainFrame

-- Slider frame
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0.8, 0, 0, 20)
SliderFrame.Position = UDim2.new(0.1, 0, 0, 90)
SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderFrame.Parent = MainFrame
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0,10)

-- Slider handle
local Handle = Instance.new("Frame")
Handle.Size = UDim2.new(0.05, 0, 1, 0)
Handle.Position = UDim2.new(0,0,0,0)
Handle.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
Handle.Parent = SliderFrame
Instance.new("UICorner", Handle).CornerRadius = UDim.new(0,10)

-- Slider dragging
local sliderDragging = false
Handle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		sliderDragging = true
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				sliderDragging = false
			end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouseX = UIS:GetMouseLocation().X
		local framePos = SliderFrame.AbsolutePosition.X
		local frameSize = SliderFrame.AbsoluteSize.X
		local newPos = math.clamp(mouseX - framePos, 0, frameSize)
		local percent = newPos / frameSize
		Handle.Position = UDim2.new(percent,0,0,0)
		local speed = math.floor(16 + percent * 64) -- 16 -> 80
		SpeedLabel.Text = "Speed Boost: "..speed
		if humanoid then
			humanoid.WalkSpeed = speed
		end
	end
end)

-- Key Frame
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 180)
KeyFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Text = "Enter Key"
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextScaled = true
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText = "Enter your key..."
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextScaled = true
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 30)
StatusText.Position = UDim2.new(0, 0, 0.7, 0)
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusText.Font = Enum.Font.Gotham
StatusText.TextScaled = true
StatusText.Text = ""
StatusText.Parent = KeyFrame

-- Check Key button
local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0.35, 0, 0, 30)
CheckKeyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.Text = "Check Key"
CheckKeyBtn.Font = Enum.Font.Gotham
CheckKeyBtn.TextScaled = true
CheckKeyBtn.Parent = KeyFrame
Instance.new("UICorner", CheckKeyBtn).CornerRadius = UDim.new(0, 8)

-- Discord button
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.35, 0, 0, 30)
DiscordBtn.Position = UDim2.new(0.55, 0, 0.55, 0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Text = "Discord"
DiscordBtn.Font = Enum.Font.Gotham
DiscordBtn.TextScaled = true
DiscordBtn.Parent = KeyFrame
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

-- Notification
local function ShowNotification(msg, color)
	local Notification = Instance.new("TextLabel")
	Notification.Size = UDim2.new(0, 200, 0, 40)
	Notification.Position = UDim2.new(0.5, -100, 0.1, 0)
	Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Notification.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	Notification.Text = msg
	Notification.TextScaled = true
	Notification.Font = Enum.Font.Gotham
	Notification.Parent = ScreenGui
	Instance.new("UICorner", Notification).CornerRadius = UDim.new(0, 8)
	game:GetService("Debris"):AddItem(Notification, 2)
end

-- Key check
CheckKeyBtn.MouseButton1Click:Connect(function()
	if KeyBox.Text == VALID_KEY then
		StatusText.Text = ""
		KeyFrame.Visible = false
		ShowNotification("Loading IEEF HUB...", Color3.fromRGB(0, 255, 128))
		task.wait(1.5)
		MainFrame.Visible = true
	else
		StatusText.Text = "Invalid Key"
	end
end)

-- Discord button
DiscordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DISCORD_LINK)
		ShowNotification("Discord link copied!", Color3.fromRGB(0, 255, 128))
	end
end)

-- Toggle menu with RightShift
UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
