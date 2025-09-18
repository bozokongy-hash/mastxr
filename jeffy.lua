-- LocalScript: Steal a Jeffy OP Menu v1.0
-- Place inside StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Steal_Jeffy_OP_Menu"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local function ShowNotification(msg,color)
	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0,250,0,30)
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

local function makeDraggable(frame)
	local dragging = false
	local dragInput, mousePos, framePos
	local function update(input)
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,280,0,350)
MainFrame.Position = UDim2.new(0,10,0,50)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)
makeDraggable(MainFrame)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Steal a Jeffy OP Menu"
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = MainFrame

-- Button Creator
local function createButton(text,pos,color,callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8,0,0,30)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.Parent = MainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Feature Toggles
local speedActive = false
local noclipActive = false
local autoStealActive = false

-- Speed Button (125)
createButton("Speed Boost (125)", UDim2.new(0.1,0,0,50), Color3.fromRGB(0,200,0), function()
	speedActive = not speedActive
	humanoid.WalkSpeed = speedActive and 125 or 16
	ShowNotification(speedActive and "Speed ON" or "Speed OFF", speedActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,255,255))
end)

-- Noclip Button
createButton("Noclip", UDim2.new(0.1,0,0,100), Color3.fromRGB(200,0,0), function()
	noclipActive = not noclipActive
	ShowNotification(noclipActive and "Noclip ON" or "Noclip OFF", noclipActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0))
end)

-- Auto Steal Jeffy
createButton("Auto Steal Jeffy", UDim2.new(0.1,0,0,150), Color3.fromRGB(200,0,200), function()
	autoStealActive = not autoStealActive
	ShowNotification(autoStealActive and "Auto Steal ON" or "Auto Steal OFF", autoStealActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0))
end)

-- Teleport Button (example)
createButton("Teleport to Jeffy", UDim2.new(0.1,0,0,200), Color3.fromRGB(0,0,200), function()
	local jeffy = workspace:FindFirstChild("Jeffy")
	if jeffy and jeffy:FindFirstChild("HumanoidRootPart") then
		character:MoveTo(jeffy.HumanoidRootPart.Position)
		ShowNotification("Teleported to Jeffy!", Color3.fromRGB(0,255,255))
	end
end)

-- ESP Visual Enemy (simple box)
createButton("Visual Enemy", UDim2.new(0.1,0,0,250), Color3.fromRGB(255,100,0), function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local highlight = Instance.new("Highlight")
			highlight.Adornee = plr.Character
			highlight.FillColor = Color3.fromRGB(255,0,0)
			highlight.OutlineColor = Color3.fromRGB(0,0,0)
			highlight.Parent = plr.Character
		end
	end
	ShowNotification("Enemy ESP Activated", Color3.fromRGB(255,0,0))
end)

-- Main Menu Toggle
UIS.InputBegan:Connect(function(input,gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- Noclip loop
RunService.Stepped:Connect(function()
	if noclipActive and character and character:FindFirstChild("HumanoidRootPart") then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Auto Steal loop (simple example, teleport to Jeffy)
RunService.Heartbeat:Connect(function()
	if autoStealActive and character and workspace:FindFirstChild("Jeffy") and workspace.Jeffy:FindFirstChild("HumanoidRootPart") then
		character:MoveTo(workspace.Jeffy.HumanoidRootPart.Position)
	end
end)
