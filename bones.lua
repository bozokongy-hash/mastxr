-- MASTXR Hub Custom GUI (Fluent-inspired style)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ========== Main ScreenGui ==========
local gui = Instance.new("ScreenGui")
gui.Name = "MASTXRHubCustom"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ========== Main Frame ==========
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 180)
frame.Position = UDim2.new(0.5, -175, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0
frame.Parent = gui
frame.ClipsDescendants = true

-- Rounded corners
local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

-- Shadow
local shadow = Instance.new("ImageLabel", frame)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217" -- subtle shadow
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.ZIndex = 0

-- ========== Title ==========
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "MASTXR Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)

-- ========== Close Button ==========
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0,3)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundTransparency = 0
closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
closeBtn.AutoButtonColor = true
local cornerBtn = Instance.new("UICorner", closeBtn)
cornerBtn.CornerRadius = UDim.new(0,5)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ========== Toggle Function ==========
local function CreateToggle(parent, name, default, callback)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(1,-40,0,40)
    btnFrame.Position = UDim2.new(0,20,0,#parent:GetChildren()*45)
    btnFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnFrame.BorderSizePixel = 0
    local uic = Instance.new("UICorner", btnFrame)
    uic.CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(0.7,0,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1

    local toggle = Instance.new("TextButton", btnFrame)
    toggle.Size = UDim2.new(0.25,0,0.6,0)
    toggle.Position = UDim2.new(0.72,0,0.2,0)
    toggle.Text = default and "ON" or "OFF"
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.BackgroundColor3 = default and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    local toggleCorner = Instance.new("UICorner", toggle)
    toggleCorner.CornerRadius = UDim.new(0,6)

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
        callback(state)
    end)
end

-- ========== Slider Function ==========
local function CreateSlider(parent, name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1,-40,0,30)
    sliderFrame.Position = UDim2.new(0,20,0,#parent:GetChildren()*35)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sliderFrame.BorderSizePixel = 0
    local uic = Instance.new("UICorner", sliderFrame)
    uic.CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(0.5,0,1,0)
    label.Position = UDim2.new(0,5,0,0)
    label.Text = name.." "..tostring(default)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1

    local bar = Instance.new("Frame", sliderFrame)
    bar.Size = UDim2.new(1, -10, 0.4, 0)
    bar.Position = UDim2.new(0,5,0.55,0)
    bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
    local barCorner = Instance.new("UICorner", bar)
    barCorner.CornerRadius = UDim.new(0,4)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(50,200,50)
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0,4)

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relative = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            fill.Size = UDim2.new(relative,0,1,0)
            local value = math.floor(min + relative*(max-min))
            label.Text = name.." "..tostring(value)
            callback(value)
        end
    end)
end

-- ========== Add Toggles and Sliders ==========
-- Auto Sit Toggle
CreateToggle(frame,"Auto Sit",false,function(state)
    print("Auto Sit:",state)
    -- connect your Auto Sit function here
end)

-- Speed Slider
CreateSlider(frame,"Speed Boost",16,100,16,function(value)
    print("Speed:",value)
    -- connect your speed ramp function here
end)

-- ========== Notification Example ==========
local function notify(msg)
    local notif = Instance.new("TextLabel", frame)
    notif.Size = UDim2.new(1,-40,0,25)
    notif.Position = UDim2.new(0,20,0,frame.Size.Y.Offset - 30)
    notif.BackgroundTransparency = 0.5
    notif.BackgroundColor3 = Color3.fromRGB(0,0,0)
    notif.TextColor3 = Color3.new(1,1,1)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 14
    notif.Text = msg
    task.delay(3,function() notif:Destroy() end)
end

notify("Custom MASTXR Hub Loaded!")
