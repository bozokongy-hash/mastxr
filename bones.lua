-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- === Remove old IEEFHub GUI (Solara-safe) ===
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "IEEFHub" then gui:Destroy() end
end
for _, gui in pairs(Player:WaitForChild("PlayerGui"):GetChildren()) do
    if gui.Name == "IEEFHub" then gui:Destroy() end
end

-- === Keys and Discord ===
local validKeys = {["IEEF-1234"]=true,["IEEF-5678"]=true,["IEEF-9012"]=true}
local discordLink = "https://discord.gg/Q9caeDr2M8"

-- === Create ScreenGui ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEFHub"
ScreenGui.Parent = CoreGui

-- === Key Frame ===
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.ClipsDescendants = true
KeyFrame.Parent = ScreenGui
local UICornerKey = Instance.new("UICorner")
UICornerKey.CornerRadius = UDim.new(0,15)
UICornerKey.Parent = KeyFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "IEEF Hub - Key"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8,0,0,30)
KeyBox.Position = UDim2.new(0.1,0,0.35,0)
KeyBox.PlaceholderText = "Enter Discord Key"
KeyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.ClearTextOnFocus = true
KeyBox.Parent = KeyFrame

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0.5,0,0,30)
SubmitButton.Position = UDim2.new(0.25,0,0.55,0)
SubmitButton.Text = "Submit"
SubmitButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
SubmitButton.TextColor3 = Color3.fromRGB(255,255,255)
SubmitButton.Parent = KeyFrame

local DiscordButton = Instance.new("TextButton")
DiscordButton.Size = UDim2.new(0.5,0,0,30)
DiscordButton.Position = UDim2.new(0.25,0,0.75,0)
DiscordButton.Text = "Copy Discord Link"
DiscordButton.BackgroundColor3 = Color3.fromRGB(100,50,200)
DiscordButton.TextColor3 = Color3.fromRGB(255,255,255)
DiscordButton.Parent = KeyFrame

DiscordButton.MouseButton1Click:Connect(function()
    -- Copy link to clipboard
    pcall(function()
        setclipboard(discordLink)
    end)

    -- Notification
    local Notification = Instance.new("TextLabel")
    Notification.Size = UDim2.new(0,200,0,50)
    Notification.Position = UDim2.new(0.5,-100,0.2,0)
    Notification.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Notification.TextColor3 = Color3.fromRGB(255,255,255)
    Notification.Text = "Discord link copied!"
    Notification.Font = Enum.Font.SourceSansBold
    Notification.TextSize = 18
    Notification.Parent = ScreenGui
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,10)
    UICorner.Parent = Notification

    -- Fade out and destroy after 2 seconds
    spawn(function()
        wait(2)
        for i=1,20 do
            Notification.TextTransparency = i*0.05
            Notification.BackgroundTransparency = i*0.05
            wait(0.05)
        end
        Notification:Destroy()
    end)
end)

-- === Draggable Function ===
local function makeDraggable(frame)
    local dragging, dragInput, mousePos, framePos = false,nil,nil,nil
    local function update(input)
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset+delta.X, framePos.Y.Scale, framePos.Y.Offset+delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            mousePos=input.Position
            framePos=frame.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement then dragInput=input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input==dragInput and dragging then update(input) end
    end)
end
makeDraggable(KeyFrame)

-- === Main Menu with Tabs ===
local function createMainMenu()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,400,0,300)
    MainFrame.Position = UDim2.new(0.5,-200,0.5,-150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    local UICornerMenu = Instance.new("UICorner")
    UICornerMenu.CornerRadius = UDim.new(0,20)
    UICornerMenu.Parent = MainFrame
    makeDraggable(MainFrame)

    local MenuTitle = Instance.new("TextLabel")
    MenuTitle.Size = UDim2.new(1,0,0,40)
    MenuTitle.Position = UDim2.new(0,0,0,0)
    MenuTitle.BackgroundTransparency = 1
    MenuTitle.Text = "IEEF Hub - Main Menu"
    MenuTitle.TextColor3 = Color3.fromRGB(255,255,255)
    MenuTitle.Font = Enum.Font.SourceSansBold
    MenuTitle.TextSize = 22
    MenuTitle.Parent = MainFrame

    -- Tab buttons container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1,0,0,30)
    TabContainer.Position = UDim2.new(0,0,0.08,0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local function createTab(name, position)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,120,1,0)
        btn.Position = UDim2.new(0,position,0,0)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Parent = TabContainer
        return btn
    end

    local ModsTab = createTab("Mods",0)
    local SettingsTab = createTab("Settings",130)

    -- Content frames
    local ModsFrame = Instance.new("Frame")
    ModsFrame.Size = UDim2.new(1,0,0.8,0)
    ModsFrame.Position = UDim2.new(0,0,0.2,0)
    ModsFrame.BackgroundTransparency = 1
    ModsFrame.Parent = MainFrame

    local ExampleModButton = Instance.new("TextButton")
    ExampleModButton.Size = UDim2.new(0.6,0,0,30)
    ExampleModButton.Position = UDim2.new(0.2,0,0.1,0)
    ExampleModButton.Text = "Example Mod"
    ExampleModButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
    ExampleModButton.TextColor3 = Color3.fromRGB(255,255,255)
    ExampleModButton.Parent = ModsFrame

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Size = UDim2.new(1,0,0.8,0)
    SettingsFrame.Position = UDim2.new(0,0,0.2,0)
    SettingsFrame.BackgroundTransparency = 1
    SettingsFrame.Visible = false
    SettingsFrame.Parent = MainFrame

    local ExampleSetting = Instance.new("TextLabel")
    ExampleSetting.Size = UDim2.new(0.8,0,0,30)
    ExampleSetting.Position = UDim2.new(0.1,0,0.1,0)
    ExampleSetting.Text = "Settings will go here"
    ExampleSetting.TextColor3 = Color3.fromRGB(255,255,255)
    ExampleSetting.BackgroundTransparency = 1
    ExampleSetting.Parent = SettingsFrame

    -- Tab switching
    ModsTab.MouseButton1Click:Connect(function()
        ModsFrame.Visible = true
        SettingsFrame.Visible = false
    end)
    SettingsTab.MouseButton1Click:Connect(function()
        ModsFrame.Visible = false
        SettingsFrame.Visible = true
    end)
end

-- === Key Validation ===
SubmitButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if validKeys[key] then
        KeyFrame:Destroy()
        createMainMenu()
    else
        Title.Text = "Invalid Key! Copy Discord link above."
    end
end)
