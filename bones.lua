-- ================== GUI Setup (Upgraded) ==================
local gui = Instance.new("ScreenGui")
gui.Name = "MASTXRHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 180)
frame.Position = UDim2.new(0.5, -170, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Round corners
local uICorner = Instance.new("UICorner", frame)
uICorner.CornerRadius = UDim.new(0, 12)

-- Neon red outline
local uIStroke = Instance.new("UIStroke", frame)
uIStroke.Thickness = 3
uIStroke.Color = Color3.fromRGB(255, 0, 0)
uIStroke.Transparency = 0
uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,6)

-- Auto Sit Button
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1,-40,0,40)
autoBtn.Position = UDim2.new(0,20,0,50)
autoBtn.Font = Enum.Font.SourceSansBold
autoBtn.TextSize = 18
autoBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Text = "🔁 Auto Sit OFF"
local autoCorner = Instance.new("UICorner", autoBtn)
autoCorner.CornerRadius = UDim.new(0,8)
local autoStroke = Instance.new("UIStroke", autoBtn)
autoStroke.Color = Color3.fromRGB(255,0,0)
autoStroke.Thickness = 2

-- Speed Label
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1,-40,0,25)
speedLabel.Position = UDim2.new(0,20,0,100)
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 16
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"

-- Speed Slider
local speedSlider = Instance.new("TextButton", frame)
speedSlider.Size = UDim2.new(1,-40,0,25)
speedSlider.Position = UDim2.new(0,20,0,125)
speedSlider.Font = Enum.Font.SourceSansBold
speedSlider.TextSize = 14
speedSlider.TextColor3 = Color3.new(1,1,1)
speedSlider.Text = "Adjust Speed"
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,60)
local sliderCorner = Instance.new("UICorner", speedSlider)
sliderCorner.CornerRadius = UDim.new(0,6)
local sliderStroke = Instance.new("UIStroke", speedSlider)
sliderStroke.Color = Color3.fromRGB(255,0,0)
sliderStroke.Thickness = 2

-- Close button logic
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
