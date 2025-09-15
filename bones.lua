-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- === Pre-generated Discord keys ===
local validKeys = {
    ["IEEF-1234"] = true,
    ["IEEF-5678"] = true,
    ["IEEF-9012"] = true,
}

-- === Your Discord Invite Link ===
local discordLink = "https://discord.gg/YOUR_INVITE" -- Replace with your server invite

-- === Create ScreenGui ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEFHub"
ScreenGui.Parent = CoreGui

-- === Key Frame ===
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "IEEF Hub - Key"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 30)
KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText = "Enter Discord Key"
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.ClearTextOnFocus = true
KeyBox.Parent = KeyFrame

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0.5, 0, 0, 30)
SubmitButton.Position = UDim2.new(0.25, 0, 0.55, 0)
SubmitButton.Text = "Submit"
SubmitButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.Parent = KeyFrame

-- === Discord Button ===
local DiscordButton = Instance.new("TextButton")
DiscordButton.Size = UDim2.new(0.5, 0, 0, 30)
DiscordButton.Position = UDim2.new(0.25, 0, 0.75, 0)
DiscordButton.Text = "Join Discord"
DiscordButton.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.Parent = KeyFrame

DiscordButton.MouseButton1Click:Connect(function()
    -- Attempt to open the Discord invite
    -- Roblox will try to open it in the default browser or Discord app
    if RunService:IsStudio() then
        print("Studio detected! Discord link: "..discordLink)
    else
        -- Use Roblox's 'TeleportService' hack to open URL in browser
        -- This will prompt the user
        local success, err = pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(discordLink)
        end)
        if not success then
            warn("Failed to open Discord link: "..tostring(err))
        end
    end
end)

-- === Draggable Key Frame ===
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
    local delta = input.Position - mousePos
    KeyFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end

KeyFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = KeyFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

KeyFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- === Main Menu GUI ===
local function createMainMenu()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MenuTitle = Instance.new("TextLabel")
    MenuTitle.Size = UDim2.new(1, 0, 0, 40)
    MenuTitle.Position = UDim2.new(0, 0, 0, 0)
    MenuTitle.BackgroundTransparency = 1
    MenuTitle.Text = "IEEF Hub - Main Menu"
    MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MenuTitle.Font = Enum.Font.SourceSansBold
    MenuTitle.TextSize = 22
    MenuTitle.Parent = MainFrame

    -- Example placeholder button
    local ExampleButton = Instance.new("TextButton")
    ExampleButton.Size = UDim2.new(0.6, 0, 0, 30)
    ExampleButton.Position = UDim2.new(0.2, 0, 0.5, 0)
    ExampleButton.Text = "Example Mod"
    ExampleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    ExampleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExampleButton.Parent = MainFrame
end

-- === Key validation ===
SubmitButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if validKeys[key] then
        -- Destroy key screen and load main menu
        KeyFrame:Destroy()
        createMainMenu()
    else
        Title.Text = "Invalid Key! Join our Discord."
    end
end)
