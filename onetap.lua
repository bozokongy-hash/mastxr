local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bozokongy-hash/SwebLib/refs/heads/main/source.lua"))()

local keyPassed = Library:CreateKeySystem({
	Key = "SWEB788",
	DiscordLink = "discord.gg/Q9caeDr2M8",
	SaveFile = "swebware_onetap.txt",
	Title = "SWEBWARE ONE TAP",
	Footer = "Key is in our discord!"
})

if not keyPassed then return end

local Window = Library:CreateWindow({
	Title = "SwebWare One Shot",
	Subtitle = "Version 1.0",
	BrandText = "Join SwebWare",
	DiscordLink = "discord.gg/Q9caeDr2M8",
	ToggleKey = Enum.KeyCode.RightControl,
	Size = UDim2.new(0, 700, 0, 480)
})

local AimAssistPage = Window:CreatePage("Aim Assist")
local VisualsPage = Window:CreatePage("Visuals")
local TriggerbotPage = Window:CreatePage("Triggerbot")
local HitboxPage = Window:CreatePage("Hitbox")

-- Aim Assist Tab
_G.AimAssistEnabled = false
_G.TeamCheck = true
_G.VisibleCheck = true
_G.AimSmoothness = 50
_G.FOVSize = 200
_G.AimPart = "Head"
_G.ShowFOV = false
_G.PredictMovement = false
_G.PredictionStrength = 0.1
_G.AimKey = "MouseButton2"
_G.StickyAim = false
_G.ShakeReduction = false

Window:CreateToggle({
	Parent = AimAssistPage.Content,
	Text = "Enable Aim Assist",
	Default = false,
	Callback = function(value)
		_G.AimAssistEnabled = value
	end
})

Window:CreateToggle({
	Parent = AimAssistPage.Content,
	Text = "Team Check",
	Default = true,
	Callback = function(value)
		_G.TeamCheck = value
	end
})

Window:CreateToggle({
	Parent = AimAssistPage.Content,
	Text = "Visible Check",
	Default = true,
	Callback = function(value)
		_G.VisibleCheck = value
	end
})

Window:CreateSlider({
	Parent = AimAssistPage.Content,
	Text = "Smoothness",
	Min = 1,
	Max = 100,
	Default = 50,
	Callback = function(value)
		_G.AimSmoothness = value
	end
})

Window:CreateSlider({
	Parent = AimAssistPage.Content,
	Text = "FOV Size",
	Min = 50,
	Max = 500,
	Default = 200,
	Callback = function(value)
		_G.FOVSize = value
	end
})

Window:CreateDropdown({
	Parent = AimAssistPage.Content,
	Text = "Aim Part",
	Options = {"Head", "Torso", "HumanoidRootPart"},
	Default = "Head",
	Callback = function(value)
		_G.AimPart = value
	end
})

Window:CreateToggle({
	Parent = AimAssistPage.Content,
	Text = "Show FOV Circle",
	Default = false,
	Callback = function(value)
		_G.ShowFOV = value
	end
})

Window:CreateToggle({
	Parent = AimAssistPage.Content,
	Text = "Predict Movement",
	Default = false,
	Callback = function(value)
		_G.PredictMovement = value
	end
})

Window:CreateSlider({
	Parent = AimAssistPage.Content,
	Text = "Prediction Strength",
	Min = 0,
	Max = 100,
	Default = 10,
	Callback = function(value)
		_G.PredictionStrength = value / 100
	end
})

Window:CreateToggle({
	Parent = AimAssistPage.Content,
	Text = "Sticky Aim",
	Default = false,
	Callback = function(value)
		_G.StickyAim = value
	end
})

Window:CreateToggle({
	Parent = AimAssistPage.Content,
	Text = "Shake Reduction",
	Default = false,
	Callback = function(value)
		_G.ShakeReduction = value
	end
})

Window:CreateDropdown({
	Parent = AimAssistPage.Content,
	Text = "Aim Key",
	Options = {"MouseButton2", "MouseButton1", "Q", "E", "C"},
	Default = "MouseButton2",
	Callback = function(value)
		_G.AimKey = value
	end
})

-- Aim Assist Logic
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 50
FOVCircle.Radius = _G.FOVSize
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Visible = _G.ShowFOV

-- Update FOV Circle
RunService.RenderStepped:Connect(function()
	FOVCircle.Radius = _G.FOVSize
	FOVCircle.Position = UserInputService:GetMouseLocation()
	FOVCircle.Visible = _G.ShowFOV
end)

-- Get Closest Player
local function GetClosestPlayer()
	local ClosestPlayer = nil
	local ShortestDistance = math.huge
	
	for _, Player in pairs(Players:GetPlayers()) do
		if Player ~= LocalPlayer and Player.Character then
			local Character = Player.Character
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			
			if Humanoid and Humanoid.Health > 0 then
				-- Team Check
				if _G.TeamCheck and Player.Team == LocalPlayer.Team then continue end
				
				local Part = Character:FindFirstChild(_G.AimPart)
				if not Part then continue end
				
				-- Visible Check
				if _G.VisibleCheck then
					local Ray = Ray.new(Camera.CFrame.Position, (Part.Position - Camera.CFrame.Position).Unit * 1000)
					local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character})
					if Hit and not Hit:IsDescendantOf(Character) then continue end
				end
				
				local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
				if OnScreen then
					local MousePos = UserInputService:GetMouseLocation()
					local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
					
					if Distance < _G.FOVSize and Distance < ShortestDistance then
						ClosestPlayer = Player
						ShortestDistance = Distance
					end
				end
			end
		end
	end
	
	return ClosestPlayer
end

-- Aim Assist Loop
local LastTarget = nil
RunService.RenderStepped:Connect(function()
	if not _G.AimAssistEnabled then return end
	
	local isAiming = false
	if _G.AimKey == "MouseButton2" then
		isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	elseif _G.AimKey == "MouseButton1" then
		isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
	else
		isAiming = UserInputService:IsKeyDown(Enum.KeyCode[_G.AimKey])
	end
	
	if not isAiming then 
		LastTarget = nil
		return 
	end
	
	local Target = _G.StickyAim and LastTarget or GetClosestPlayer()
	if not Target or not Target.Character then 
		LastTarget = nil
		return 
	end
	
	LastTarget = Target
	
	local Part = Target.Character:FindFirstChild(_G.AimPart)
	if not Part then return end
	
	local TargetPosition = Part.Position
	
	-- Predict Movement
	if _G.PredictMovement then
		local TargetVelocity = Part.AssemblyLinearVelocity or Part.Velocity or Vector3.new(0, 0, 0)
		TargetPosition = TargetPosition + (TargetVelocity * _G.PredictionStrength)
	end
	
	local TargetPos = Camera:WorldToViewportPoint(TargetPosition)
	local MousePos = UserInputService:GetMouseLocation()
	
	local MoveX = (TargetPos.X - MousePos.X) / _G.AimSmoothness
	local MoveY = (TargetPos.Y - MousePos.Y) / _G.AimSmoothness
	
	-- Shake Reduction
	if _G.ShakeReduction then
		MoveX = math.floor(MoveX * 10) / 10
		MoveY = math.floor(MoveY * 10) / 10
	end
	
	mousemoverel(MoveX, MoveY)
end)

-- Visuals Tab
_G.ESPEnabled = false
_G.NameESP = true
_G.DistanceESP = true
_G.HealthESP = true
_G.BoxESP = false
_G.Tracers = false
_G.ESPDistance = 2000
_G.ESPColor = "White"
_G.SkeletonESP = false
_G.HeadDot = false
_G.LookDirection = false
_G.ChamsEnabled = false
_G.HighlightEnabled = false

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Enable ESP",
	Default = false,
	Callback = function(value)
		_G.ESPEnabled = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Name ESP",
	Default = true,
	Callback = function(value)
		_G.NameESP = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Distance ESP",
	Default = true,
	Callback = function(value)
		_G.DistanceESP = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Health ESP",
	Default = true,
	Callback = function(value)
		_G.HealthESP = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Box ESP",
	Default = false,
	Callback = function(value)
		_G.BoxESP = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Tracers",
	Default = false,
	Callback = function(value)
		_G.Tracers = value
	end
})

Window:CreateSlider({
	Parent = VisualsPage.Content,
	Text = "ESP Render Distance",
	Min = 100,
	Max = 5000,
	Default = 2000,
	Callback = function(value)
		_G.ESPDistance = value
	end
})

Window:CreateDropdown({
	Parent = VisualsPage.Content,
	Text = "ESP Color",
	Options = {"Red", "Green", "Blue", "White", "Rainbow"},
	Default = "White",
	Callback = function(value)
		_G.ESPColor = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Skeleton ESP",
	Default = false,
	Callback = function(value)
		_G.SkeletonESP = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Head Dot",
	Default = false,
	Callback = function(value)
		_G.HeadDot = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Look Direction",
	Default = false,
	Callback = function(value)
		_G.LookDirection = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Chams",
	Default = false,
	Callback = function(value)
		_G.ChamsEnabled = value
	end
})

Window:CreateToggle({
	Parent = VisualsPage.Content,
	Text = "Highlight Players",
	Default = false,
	Callback = function(value)
		_G.HighlightEnabled = value
	end
})

-- ESP System
local ESPObjects = {}
local Highlights = {}

local function GetColor()
	if _G.ESPColor == "Red" then
		return Color3.fromRGB(255, 0, 0)
	elseif _G.ESPColor == "Green" then
		return Color3.fromRGB(0, 255, 0)
	elseif _G.ESPColor == "Blue" then
		return Color3.fromRGB(0, 100, 255)
	elseif _G.ESPColor == "White" then
		return Color3.fromRGB(255, 255, 255)
	elseif _G.ESPColor == "Rainbow" then
		local hue = tick() % 5 / 5
		return Color3.fromHSV(hue, 1, 1)
	end
end

local function CreateESP(player)
	if ESPObjects[player] then return end
	
	local ESPHolder = {}
	
	-- Name ESP
	local NameLabel = Drawing.new("Text")
	NameLabel.Visible = false
	NameLabel.Center = true
	NameLabel.Outline = true
	NameLabel.Size = 16
	NameLabel.Color = Color3.fromRGB(255, 255, 255)
	ESPHolder.Name = NameLabel
	
	-- Distance ESP
	local DistanceLabel = Drawing.new("Text")
	DistanceLabel.Visible = false
	DistanceLabel.Center = true
	DistanceLabel.Outline = true
	DistanceLabel.Size = 14
	DistanceLabel.Color = Color3.fromRGB(255, 255, 255)
	ESPHolder.Distance = DistanceLabel
	
	-- Health ESP
	local HealthLabel = Drawing.new("Text")
	HealthLabel.Visible = false
	HealthLabel.Center = true
	HealthLabel.Outline = true
	HealthLabel.Size = 14
	HealthLabel.Color = Color3.fromRGB(0, 255, 0)
	ESPHolder.Health = HealthLabel
	
	-- Box ESP
	local BoxOutline = Drawing.new("Square")
	BoxOutline.Visible = false
	BoxOutline.Filled = false
	BoxOutline.Thickness = 3
	BoxOutline.Color = Color3.fromRGB(0, 0, 0)
	ESPHolder.BoxOutline = BoxOutline
	
	local Box = Drawing.new("Square")
	Box.Visible = false
	Box.Filled = false
	Box.Thickness = 1
	Box.Color = Color3.fromRGB(255, 255, 255)
	ESPHolder.Box = Box
	
	-- Tracer
	local Tracer = Drawing.new("Line")
	Tracer.Visible = false
	Tracer.Thickness = 1
	Tracer.Color = Color3.fromRGB(255, 255, 255)
	ESPHolder.Tracer = Tracer
	
	-- Head Dot
	local HeadDot = Drawing.new("Circle")
	HeadDot.Visible = false
	HeadDot.Filled = true
	HeadDot.Radius = 4
	HeadDot.Color = Color3.fromRGB(255, 0, 0)
	ESPHolder.HeadDot = HeadDot
	
	-- Look Direction
	local LookLine = Drawing.new("Line")
	LookLine.Visible = false
	LookLine.Thickness = 2
	LookLine.Color = Color3.fromRGB(255, 255, 0)
	ESPHolder.LookLine = LookLine
	
	-- Skeleton Lines
	ESPHolder.Skeleton = {}
	for i = 1, 15 do
		local line = Drawing.new("Line")
		line.Visible = false
		line.Thickness = 1
		line.Color = Color3.fromRGB(255, 255, 255)
		table.insert(ESPHolder.Skeleton, line)
	end
	
	ESPObjects[player] = ESPHolder
end

local function RemoveESP(player)
	if ESPObjects[player] then
		for _, obj in pairs(ESPObjects[player]) do
			obj:Remove()
		end
		ESPObjects[player] = nil
	end
end

local function UpdateESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			CreateESP(player)
			
			local ESPHolder = ESPObjects[player]
			if not ESPHolder then continue end
			
			local character = player.Character
			if not character then
				for _, obj in pairs(ESPHolder) do
					obj.Visible = false
				end
				continue
			end
			
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local head = character:FindFirstChild("Head")
			
			if not rootPart or not humanoid or humanoid.Health <= 0 then
				for _, obj in pairs(ESPHolder) do
					obj.Visible = false
				end
				continue
			end
			
			local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
			
			if distance > _G.ESPDistance then
				for _, obj in pairs(ESPHolder) do
					obj.Visible = false
				end
				continue
			end
			
			local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
			
			if not onScreen or not _G.ESPEnabled then
				for _, obj in pairs(ESPHolder) do
					obj.Visible = false
				end
				continue
			end
			
			local color = GetColor()
			
			-- Name ESP
			if _G.NameESP and head then
				local headPos = Camera:WorldToViewportPoint(head.Position)
				ESPHolder.Name.Position = Vector2.new(headPos.X, headPos.Y - 30)
				ESPHolder.Name.Text = player.Name
				ESPHolder.Name.Color = color
				ESPHolder.Name.Visible = true
			else
				ESPHolder.Name.Visible = false
			end
			
			-- Distance ESP
			if _G.DistanceESP then
				ESPHolder.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + 15)
				ESPHolder.Distance.Text = string.format("[%d studs]", math.floor(distance))
				ESPHolder.Distance.Color = color
				ESPHolder.Distance.Visible = true
			else
				ESPHolder.Distance.Visible = false
			end
			
			-- Health ESP
			if _G.HealthESP then
				local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
				ESPHolder.Health.Position = Vector2.new(screenPos.X, screenPos.Y)
				ESPHolder.Health.Text = string.format("HP: %d%%", healthPercent)
				
				if healthPercent > 75 then
					ESPHolder.Health.Color = Color3.fromRGB(0, 255, 0)
				elseif healthPercent > 50 then
					ESPHolder.Health.Color = Color3.fromRGB(255, 255, 0)
				elseif healthPercent > 25 then
					ESPHolder.Health.Color = Color3.fromRGB(255, 165, 0)
				else
					ESPHolder.Health.Color = Color3.fromRGB(255, 0, 0)
				end
				
				ESPHolder.Health.Visible = true
			else
				ESPHolder.Health.Visible = false
			end
			
			-- Box ESP
			if _G.BoxESP and head then
				local headPos = Camera:WorldToViewportPoint(head.Position)
				local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
				
				local height = math.abs(headPos.Y - legPos.Y)
				local width = height / 2
				
				ESPHolder.Box.Size = Vector2.new(width, height)
				ESPHolder.Box.Position = Vector2.new(screenPos.X - width / 2, headPos.Y)
				ESPHolder.Box.Color = color
				ESPHolder.Box.Visible = true
				
				ESPHolder.BoxOutline.Size = ESPHolder.Box.Size
				ESPHolder.BoxOutline.Position = ESPHolder.Box.Position
				ESPHolder.BoxOutline.Visible = true
			else
				ESPHolder.Box.Visible = false
				ESPHolder.BoxOutline.Visible = false
			end
			
			-- Tracers
			if _G.Tracers then
				local viewportSize = Camera.ViewportSize
				ESPHolder.Tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
				ESPHolder.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
				ESPHolder.Tracer.Color = color
				ESPHolder.Tracer.Visible = true
			else
				ESPHolder.Tracer.Visible = false
			end
			
			-- Head Dot
			if _G.HeadDot and head then
				local headPos = Camera:WorldToViewportPoint(head.Position)
				ESPHolder.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
				ESPHolder.HeadDot.Color = color
				ESPHolder.HeadDot.Visible = true
			else
				ESPHolder.HeadDot.Visible = false
			end
			
			-- Look Direction
			if _G.LookDirection and head then
				local headPos = Camera:WorldToViewportPoint(head.Position)
				local lookVector = head.CFrame.LookVector * 5
				local endPos = Camera:WorldToViewportPoint(head.Position + lookVector)
				ESPHolder.LookLine.From = Vector2.new(headPos.X, headPos.Y)
				ESPHolder.LookLine.To = Vector2.new(endPos.X, endPos.Y)
				ESPHolder.LookLine.Color = color
				ESPHolder.LookLine.Visible = true
			else
				ESPHolder.LookLine.Visible = false
			end
			
			-- Skeleton ESP
			if _G.SkeletonESP then
				local function drawLine(lineIndex, part1Name, part2Name)
					local part1 = character:FindFirstChild(part1Name)
					local part2 = character:FindFirstChild(part2Name)
					
					if part1 and part2 and ESPHolder.Skeleton[lineIndex] then
						local pos1 = Camera:WorldToViewportPoint(part1.Position)
						local pos2 = Camera:WorldToViewportPoint(part2.Position)
						
						ESPHolder.Skeleton[lineIndex].From = Vector2.new(pos1.X, pos1.Y)
						ESPHolder.Skeleton[lineIndex].To = Vector2.new(pos2.X, pos2.Y)
						ESPHolder.Skeleton[lineIndex].Color = color
						ESPHolder.Skeleton[lineIndex].Visible = true
					elseif ESPHolder.Skeleton[lineIndex] then
						ESPHolder.Skeleton[lineIndex].Visible = false
					end
				end
				
				-- Head to torso
				drawLine(1, "Head", "UpperTorso")
				drawLine(2, "UpperTorso", "LowerTorso")
				
				-- Arms
				drawLine(3, "UpperTorso", "LeftUpperArm")
				drawLine(4, "LeftUpperArm", "LeftLowerArm")
				drawLine(5, "LeftLowerArm", "LeftHand")
				
				drawLine(6, "UpperTorso", "RightUpperArm")
				drawLine(7, "RightUpperArm", "RightLowerArm")
				drawLine(8, "RightLowerArm", "RightHand")
				
				-- Legs
				drawLine(9, "LowerTorso", "LeftUpperLeg")
				drawLine(10, "LeftUpperLeg", "LeftLowerLeg")
				drawLine(11, "LeftLowerLeg", "LeftFoot")
				
				drawLine(12, "LowerTorso", "RightUpperLeg")
				drawLine(13, "RightUpperLeg", "RightLowerLeg")
				drawLine(14, "RightLowerLeg", "RightFoot")
			else
				for _, line in pairs(ESPHolder.Skeleton) do
					line.Visible = false
				end
			end
			
			-- Chams & Highlight
			if _G.ChamsEnabled or _G.HighlightEnabled then
				if not Highlights[player] then
					local highlight = Instance.new("Highlight")
					highlight.Parent = character
					highlight.Adornee = character
					highlight.FillTransparency = _G.ChamsEnabled and 0.5 or 1
					highlight.OutlineTransparency = 0
					highlight.FillColor = color
					highlight.OutlineColor = color
					Highlights[player] = highlight
				else
					Highlights[player].FillColor = color
					Highlights[player].OutlineColor = color
					Highlights[player].FillTransparency = _G.ChamsEnabled and 0.5 or 1
					Highlights[player].Enabled = true
				end
			else
				if Highlights[player] then
					Highlights[player].Enabled = false
				end
			end
		end
	end
end

-- Update ESP Loop
RunService.RenderStepped:Connect(UpdateESP)

-- Handle Player Addition/Removal
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- Triggerbot Tab
_G.TriggerbotEnabled = false
_G.TriggerbotDelay = 0
_G.TriggerbotTeamCheck = true
_G.TriggerbotMode = "Click"
_G.TriggerbotHoldTime = 50
_G.TriggerbotBurstCount = 1
_G.TriggerbotBurstDelay = 100
_G.TriggerbotWallCheck = true
_G.TriggerbotIgnoreForceField = true

Window:CreateToggle({
	Parent = TriggerbotPage.Content,
	Text = "Enable Triggerbot",
	Default = false,
	Callback = function(value)
		_G.TriggerbotEnabled = value
	end
})

Window:CreateToggle({
	Parent = TriggerbotPage.Content,
	Text = "Team Check",
	Default = true,
	Callback = function(value)
		_G.TriggerbotTeamCheck = value
	end
})

Window:CreateToggle({
	Parent = TriggerbotPage.Content,
	Text = "Wall Check",
	Default = true,
	Callback = function(value)
		_G.TriggerbotWallCheck = value
	end
})

Window:CreateToggle({
	Parent = TriggerbotPage.Content,
	Text = "Ignore Force Field",
	Default = true,
	Callback = function(value)
		_G.TriggerbotIgnoreForceField = value
	end
})

Window:CreateSlider({
	Parent = TriggerbotPage.Content,
	Text = "Delay (ms)",
	Min = 0,
	Max = 500,
	Default = 0,
	Callback = function(value)
		_G.TriggerbotDelay = value
	end
})

Window:CreateDropdown({
	Parent = TriggerbotPage.Content,
	Text = "Mode",
	Options = {"Click", "Hold", "Burst"},
	Default = "Click",
	Callback = function(value)
		_G.TriggerbotMode = value
	end
})

Window:CreateSlider({
	Parent = TriggerbotPage.Content,
	Text = "Hold Time (ms)",
	Min = 10,
	Max = 500,
	Default = 50,
	Callback = function(value)
		_G.TriggerbotHoldTime = value
	end
})

Window:CreateSlider({
	Parent = TriggerbotPage.Content,
	Text = "Burst Count",
	Min = 1,
	Max = 10,
	Default = 1,
	Callback = function(value)
		_G.TriggerbotBurstCount = value
	end
})

Window:CreateSlider({
	Parent = TriggerbotPage.Content,
	Text = "Burst Delay (ms)",
	Min = 50,
	Max = 500,
	Default = 100,
	Callback = function(value)
		_G.TriggerbotBurstDelay = value
	end
})

-- Triggerbot Logic
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local lastTriggerTime = 0

game:GetService("RunService").RenderStepped:Connect(function()
	if not _G.TriggerbotEnabled then return end
	if tick() - lastTriggerTime < (_G.TriggerbotDelay / 1000) then return end
	
	local Target = Mouse.Target
	if not Target then return end
	
	local TargetPlayer = Players:GetPlayerFromCharacter(Target.Parent)
	if not TargetPlayer then return end
	
	-- Team check
	if _G.TriggerbotTeamCheck and TargetPlayer.Team == LocalPlayer.Team then return end
	
	-- Check if target has humanoid and is alive
	local Humanoid = Target.Parent:FindFirstChildOfClass("Humanoid")
	if not Humanoid or Humanoid.Health <= 0 then return end
	
	-- Force field check
	if _G.TriggerbotIgnoreForceField and Target.Parent:FindFirstChildOfClass("ForceField") then return end
	
	-- Wall check
	if _G.TriggerbotWallCheck and LocalPlayer.Character then
		local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if RootPart then
			local Ray = Ray.new(RootPart.Position, (Target.Position - RootPart.Position).Unit * 1000)
			local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character})
			if Hit and not Hit:IsDescendantOf(Target.Parent) then return end
		end
	end
	
	lastTriggerTime = tick()
	
	-- Different shooting modes
	if _G.TriggerbotMode == "Click" then
		mouse1click()
	elseif _G.TriggerbotMode == "Hold" then
		mouse1press()
		wait(_G.TriggerbotHoldTime / 1000)
		mouse1release()
	elseif _G.TriggerbotMode == "Burst" then
		for i = 1, _G.TriggerbotBurstCount do
			mouse1click()
			if i < _G.TriggerbotBurstCount then
				wait(_G.TriggerbotBurstDelay / 1000)
			end
		end
	end
end)

-- Hitbox Tab
_G.HitboxExpander = false
_G.HitboxSize = 10
_G.HitboxPart = "HumanoidRootPart"
_G.HitboxTransparency = 0.5
_G.HitboxTeamCheck = true

Window:CreateToggle({
	Parent = HitboxPage.Content,
	Text = "Enable Hitbox Expander",
	Default = false,
	Callback = function(value)
		_G.HitboxExpander = value
	end
})

Window:CreateToggle({
	Parent = HitboxPage.Content,
	Text = "Team Check",
	Default = true,
	Callback = function(value)
		_G.HitboxTeamCheck = value
	end
})

Window:CreateSlider({
	Parent = HitboxPage.Content,
	Text = "Hitbox Size",
	Min = 1,
	Max = 50,
	Default = 10,
	Callback = function(value)
		_G.HitboxSize = value
	end
})

Window:CreateSlider({
	Parent = HitboxPage.Content,
	Text = "Transparency",
	Min = 0,
	Max = 100,
	Default = 50,
	Callback = function(value)
		_G.HitboxTransparency = value / 100
	end
})

Window:CreateDropdown({
	Parent = HitboxPage.Content,
	Text = "Expand Part",
	Options = {"HumanoidRootPart", "Head", "Torso", "All"},
	Default = "HumanoidRootPart",
	Callback = function(value)
		_G.HitboxPart = value
	end
})

Window:CreateDropdown({
	Parent = HitboxPage.Content,
	Text = "Theme",
	Options = {"Dark", "Light", "Blue"},
	Default = "Dark",
	Callback = function(value)
		print("Theme:", value)
	end
})

Window:CreateLabel({
	Parent = HitboxPage.Content,
	Text = "Made by SwebWare Team"
})

Window:CreateLabel({
	Parent = HitboxPage.Content,
	Text = "Version 1.0 - Updated 2026"
})

-- Hitbox Expander Logic
local originalSizes = {}

game:GetService("RunService").RenderStepped:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if _G.HitboxTeamCheck and player.Team == LocalPlayer.Team then continue end
			
			local function expandPart(partName)
				local part = player.Character:FindFirstChild(partName)
				if part and part:IsA("BasePart") then
					if not originalSizes[part] then
						originalSizes[part] = part.Size
					end
					
					if _G.HitboxExpander then
						part.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
						part.Transparency = _G.HitboxTransparency
						part.CanCollide = false
					else
						part.Size = originalSizes[part]
						part.Transparency = 0
					end
				end
			end
			
			if _G.HitboxPart == "All" then
				expandPart("Head")
				expandPart("HumanoidRootPart")
				expandPart("Torso")
				expandPart("UpperTorso")
				expandPart("LowerTorso")
			else
				expandPart(_G.HitboxPart)
			end
		end
	end
end)
