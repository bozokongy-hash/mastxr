-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- === Pre-generated Discord keys ===
local validKeys = {
    ["IEEF-1234"] = true,
    ["IEEF-5678"] = true,
    ["IEEF-9012"] = true,
}

-- === Create ScreenGui ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEFHub"
ScreenGui.Parent = CoreGui

-- === Main Frame (key entry) ===
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- === Title ===
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "IEEF Hub - Key"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- === Key input ===
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 30)
KeyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyBox.PlaceholderText = "Enter Discord Key"
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.ClearTextOnFocus = true
KeyBox.Parent = MainFrame

-- === Submit button ===
local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0.5, 0, 0, 30)
SubmitButton.Position = UDim2.new(0.25, 0, 0.7, 0)
SubmitButton.Text = "Submit"
SubmitButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.Parent = MainFrame

-- === Make frame draggable ===
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
    local delta = input.Position - mousePos
    MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- === Key validation ===
SubmitButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if validKeys[key] then
        Title.Text = "Access Granted!"
        -- Unlock your menu here later
    else
        Title.Text = "Invalid Key! Join our Discord."
    end
end)
