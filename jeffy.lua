-- LocalScript: Steal a Jeffy OP Menu v1.0 (God Mode/Admin)
-- Place inside StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- SETTINGS
local SPEED_VALUE = 125 -- WalkSpeed
local autoStealActive = false
local noclipActive = false
local espActive = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealJeffyOP"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Helper Notification
local function ShowNotification(msg,color)
	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0,300,0,30)
	notif.Position = UDim2.new(0,10,1,-170)
	notif.BackgroundColor3 = Color3.fromRGB(30,30,30)
	notif.TextColor3 = color or Color3.fromRGB(255,255,255)
	notif.TextScaled = true
	notif.Font = Enum.Font.Gotham
	notif.Text = msg
	notif.Parent = ScreenGui
	Instance.new("UICorner", notif).CornerRadius = UDim.new(0,6)
	Debris:AddItem(notif,2)
end

-- Draggable Frame Function
local function makeDraggable(frame)
	local dragging = false
	local dragInput, mousePos, framePos
	local function update(input)
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset+delta.X, framePos.Y.Scale, framePos.Y.Offset+delta.Y)
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,300,0,400)
MainFrame.Position = UDim2.new(0,50,0,50)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
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

-- SPEED TOGGLE
local speedActive = false
createButton("Speed Boost ("..SPEED_VALUE..")", UDim2.new(0.1,0,0,50), Color3.fromRGB(0,200,0), function()
	speedActive = not speedActive
	humanoid.WalkSpeed = speedActive and SPEED_VALUE or 16
	ShowNotification(speedActive and "Speed ON" or "Speed OFF", speedActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,255,255))
end)

-- NOCLIP TOGGLE
createButton("Noclip", UDim2.new(0.1,0,0,100), Color3.fromRGB(200,0,0), function()
	noclipActive = not noclipActive
	ShowNotification(noclipActive and "Noclip ON" or "Noclip OFF", noclipActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0))
end)

-- AUTO STEAL TOGGLE
createButton("Auto Steal", UDim2.new(0.1,0,0,150), Color3.fromRGB(200,0,200), function()
	autoStealActive = not autoStealActive
	ShowNotification(autoStealActive and "Auto Steal ON" or "Auto Steal OFF", autoStealActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0))
end)

-- TELEPORT TO PLAYER
createButton("Teleport to Player", UDim2.new(0.1,0,0,200), Color3.fromRGB(0,0,200), function()
	local target = Players:GetPlayers()[2] -- Example: teleport to second player
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0))
		ShowNotification("Teleported to "..target.Name, Color3.fromRGB(0,255,255))
	end
end)

-- VISUAL ENEMY (ESP)
createButton("Visual Enemy ESP", UDim2.new(0.1,0,0,250), Color3.fromRGB(255,100,0), function()
	espActive = not espActive
	ShowNotification(espActive and "ESP ON" or "ESP OFF", espActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0))
end)

-- ADMIN COMMAND (example kick)
createButton("Kick Player", UDim2.new(0.1,0,0,300), Color3.fromRGB(255,0,0), function()
	local target = Players:GetPlayers()[2] -- Example: second player
	if target then
		target:Kick("Kicked by Steal a Jeffy OP Menu")
	end
end)

-- MAIN LOOP
RunService.Stepped:Connect(function()
	-- Noclip
	if noclipActive then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end

	-- Auto Steal placeholder (teleport inside bases or fire RemoteEvent if known)
	if autoStealActive then
		-- Example: teleport to all other players (simulate stealing)
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0))
			end
		end
	end

	-- ESP (Highlight enemies)
	if espActive then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and not plr.Character:FindFirstChild("ESP") then
				local h = Instance.new("Highlight")
				h.Name = "ESP"
				h.Adornee = plr.Character
				h.FillColor = Color3.fromRGB(255,0,0)
				h.OutlineColor = Color3.fromRGB(0,0,0)
				h.Parent = plr.Character
			end
		end
	end
end)

-- TOGGLE MENU VISIBILITY
UIS.InputBegan:Connect(function(input,gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
