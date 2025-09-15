-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Remove old GUI
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "IEEFHub" then gui:Destroy() end
end
for _, gui in pairs(Player:WaitForChild("PlayerGui"):GetChildren()) do
    if gui.Name == "IEEFHub" then gui:Destroy() end
end

-- Keys and Discord
local validKeys = {["IEEF-1234"]=true,["IEEF-5678"]=true,["IEEF-9012"]=true}
local discordLink = "https://discord.gg/Q9caeDr2M8"

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IEEFHub"
ScreenGui.Parent = CoreGui

-- Key Frame
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 230)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -115)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.ClipsDescendants = true
KeyFrame.Parent = ScreenGui
local UICornerKey = Instance.new("UICorner")
UICornerKey.CornerRadius = UDim.new(0,15)
UICornerKey.Parent = KeyFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,5)
Title.BackgroundTransparency = 1
Title.Text = "IEEF Hub - Key"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8,0,0,30)
KeyBox.Position = UDim2.new(0.1,0,0.35,0)
KeyBox.PlaceholderText = "Enter Discord Key"
KeyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.ClearTextOnFocus = true
KeyBox.TextScaled = true
KeyBox.Parent = KeyFrame
local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0,8)
KeyBoxCorner.Parent = KeyBox

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0.5,0,0,30)
SubmitButton.Position = UDim2.new(0.25,0,0.55,0)
SubmitButton.Text = "Submit"
SubmitButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
SubmitButton.TextColor3 = Color3.fromRGB(255,255,255)
SubmitButton.Font = Enum.Font.Gotham
SubmitButton.TextSize = 18
SubmitButton.Parent = KeyFrame
local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0,8)
SubmitCorner.Parent = SubmitButton

local DiscordButton = Instance.new("TextButton")
DiscordButton.Size = UDim2.new(0.5,0,0,30)
DiscordButton.Position = UDim2.new(0.25,0,0.75,0)
DiscordButton.Text = "Copy Discord Link"
DiscordButton.BackgroundColor3 = Color3.fromRGB(100,50,200)
DiscordButton.TextColor3 = Color3.fromRGB(255,255,255)
DiscordButton.Font = Enum.Font.Gotham
DiscordButton.TextSize = 18
DiscordButton.Parent = KeyFrame
local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0,8)
DiscordCorner.Parent = DiscordButton

-- Invalid key label (inside frame, neat)
local InvalidLabel = Instance.new("TextLabel")
InvalidLabel.Size = UDim2.new(0.9,0,0,25)
InvalidLabel.Position = UDim2.new(0.05,0,0.9,0)  -- neatly inside bottom
InvalidLabel.BackgroundTransparency = 1
InvalidLabel.TextColor3 = Color3.fromRGB(255,50,50)
InvalidLabel.Font = Enum.Font.GothamBold
InvalidLabel.TextSize = 16
InvalidLabel.Text = ""
InvalidLabel.TextWrapped = true
InvalidLabel.TextScaled = true
InvalidLabel.Parent = KeyFrame

-- Copy Discord link
DiscordButton.MouseButton1Click:Connect(function()
    pcall(setclipboard, discordLink)
    InvalidLabel.Text = "Discord link copied!"
    InvalidLabel.TextColor3 = Color3.fromRGB(0,255,0)
    wait(2)
    InvalidLabel.Text = ""
end)

-- Draggable function
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

-- Main Menu
local function createMainMenu()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,420,0,320)
    MainFrame.Position = UDim2.new(0.5,-210,0.5,-160)
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
    MenuTitle.Font = Enum.Font.GothamBold
    MenuTitle.TextSize = 22
    MenuTitle.Parent = MainFrame

    -- Tabs container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1,0,0,35)
    TabContainer.Position = UDim2.new(0,0,0.08,0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local function createTab(name, position)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,150,1,0)
        btn.Position = UDim2.new(0,position,0,0)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.TextColor3 = Color3.fromRGB(200,200,200)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 18
        btn.Parent = TabContainer
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,12)
        corner.Parent = btn

        -- Hover effect
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        end)
        btn.MouseLeave:Connect(function()
            if not btn.Active then
                btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            end
        end)
        return btn
    end

    local ModsTab = createTab("Mods",20)
    local SettingsTab = createTab("Settings",180)

    -- Frames
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
    ExampleModButton.Font = Enum.Font.Gotham
    ExampleModButton.TextSize = 18
    ExampleModButton.Parent = ModsFrame
    local modCorner = Instance.new("UICorner")
    modCorner.CornerRadius = UDim.new(0,10)
    modCorner.Parent = ExampleModButton

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
    ExampleSetting.Font = Enum.Font.Gotham
    ExampleSetting.TextSize = 18
    ExampleSetting.Parent = SettingsFrame

    -- Tab switching
    local function activateTab(activeTab, otherTab, frameToShow, frameToHide)
        activeTab.Active = true
        activeTab.BackgroundColor3 = Color3.fromRGB(100,100,100)
        otherTab.Active = false
        otherTab.BackgroundColor3 = Color3.fromRGB(50,50,50)
        frameToShow.Visible = true
        frameToHide.Visible = false
    end

    ModsTab.MouseButton1Click:Connect(function()
        activateTab(ModsTab, SettingsTab, ModsFrame, SettingsFrame)
    end)
    SettingsTab.MouseButton1Click:Connect(function()
        activateTab(SettingsTab, ModsTab, SettingsFrame, ModsFrame)
    end)

    -- Default active tab
    activateTab(ModsTab, SettingsTab, ModsFrame, SettingsFrame)
end

-- Key validation
SubmitButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if validKeys[key] then
        KeyFrame:Destroy()
        createMainMenu()
    else
        InvalidLabel.Text = "Invalid Key! Copy Discord link above."
        InvalidLabel.TextColor3 = Color3.fromRGB(255,50,50)
    end
end)
