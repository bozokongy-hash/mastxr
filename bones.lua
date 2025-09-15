--[[ 
    MASTXR Hub - Musical Chairs Edition (Upgraded GUI)
    Features: Auto Sit, Speed Boost, Anti-Kick
    Author: Top1 Sweb
--]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ================== GUI Setup ==================
local gui = Instance.new("ScreenGui")
gui.Name = "MASTXRHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 170)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Rounded corners
local uICorner = Instance.new("UICorner", frame)
uICorner.CornerRadius = UDim.new(0, 12)

-- Shadow (using UIStroke as subtle outline)
local uIStroke = Instance.new("UIStroke", frame)
uIStroke.Color = Color3.fromRGB(0,0,0)
uIStroke.Transparency = 0.7
uIStroke.Thickness = 2
uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,6)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200,0,0)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(120,0,0)}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Auto Sit Button
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1, -40, 0, 40)
autoBtn.Position = UDim2.new(0, 20, 0, 50)
autoBtn.Text = "Auto Sit OFF"
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
local autoCorner = Instance.new("UICorner", autoBtn)
autoCorner.CornerRadius = UDim.new(0, 8)
-- Hover effect
autoBtn.MouseEnter:Connect(function()
    TweenService:Create(autoBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
end)
autoBtn.MouseLeave:Connect(function()
    TweenService:Create(autoBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
end)

-- Speed label
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, -40, 0, 25)
speedLabel.Position = UDim2.new(0, 20, 0, 100)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 16
speedLabel.Text = "Speed: 16"

-- Speed adjust button
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1, -40, 0, 25)
speedBtn.Position = UDim2.new(0, 20, 0, 125)
speedBtn.Text = "Adjust Speed"
speedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedBtn.TextColor3 = Color3.fromRGB(255,255,255)
local speedCorner = Instance.new("UICorner", speedBtn)
speedCorner.CornerRadius = UDim.new(0, 6)
-- Hover effect
speedBtn.MouseEnter:Connect(function()
    TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play()
end)
speedBtn.MouseLeave:Connect(function()
    TweenService:Create(speedBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
end)

-- ================== Anti-Kick ==================
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt,false)
mt.__namecall = newcclosure(function(self,...)
    local method = getnamecallmethod()
    if method == "Kick" then return nil end
    return oldNamecall(self,...)
end)
setreadonly(mt,true)

-- ================== Auto Sit Logic ==================
local autoEnabled = false
local autoLoop
local function getTargetChair()
    local spinner = workspace:FindFirstChild("SpinnerStuff")
    if spinner and spinner:FindFirstChild("ChairSpots") then
        for _, spot in pairs(spinner.ChairSpots:GetChildren()) do
            if spot:FindFirstChild("ChairParts") and spot.ChairParts:FindFirstChild("Cushion") then
                local cushion = spot.ChairParts.Cushion
                if cushion and not cushion.Occupant then
                    return cushion
                end
            end
        end
    end
    return nil
end

local function smoothTeleport(targetPos)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CFrame = CFrame.new(targetPos + Vector3.new(0,5,0))
end

autoBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    autoBtn.Text = autoEnabled and "Auto Sit ON" or "Auto Sit OFF"

    if autoEnabled then
        autoLoop = task.spawn(function()
            while autoEnabled do
                local target = getTargetChair()
                if target then
                    smoothTeleport(target.Position)
                end
                task.wait(0.7)
            end
        end)
    else
        if autoLoop then task.cancel(autoLoop) end
    end
end)

-- ================== Speed Adjust Logic ==================
local currentSpeed = 16
speedBtn.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + 10
    if currentSpeed > 100 then currentSpeed = 16 end
    speedLabel.Text = "Speed: "..currentSpeed
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = currentSpeed
    end
end)
