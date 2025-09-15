-- Key System
local KEY = "SWEB123" -- Set your key here

-- Roblox GUI for key input
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextBox = Instance.new("TextBox")
local TextButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 200)
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, -20, 0, 50)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.Text = "Enter Key to Access SwebHub"
TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
TextLabel.TextScaled = true

TextBox.Parent = Frame
TextBox.Size = UDim2.new(1, -40, 0, 50)
TextBox.Position = UDim2.new(0, 20, 0, 70)
TextBox.PlaceholderText = "Enter Key Here"
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(50,50,50)

TextButton.Parent = Frame
TextButton.Size = UDim2.new(0, 100, 0, 40)
TextButton.Position = UDim2.new(0.5, -50, 0, 130)
TextButton.Text = "Submit"
TextButton.TextColor3 = Color3.fromRGB(255,255,255)
TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

TextButton.MouseButton1Click:Connect(function()
	if TextBox.Text == KEY then
		ScreenGui:Destroy()
		loadGUI() -- Load the GUI
	else
		TextLabel.Text = "Incorrect Key! Try Again."
	end
end)

-- Function to Load Rebranded GUI
function loadGUI()
	local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

	OrionLib:MakeNotification({
		Name = "SwebHub",
		Content = "Welcome to SwebHub!",
		Image = "rbxassetid://4483345998",
		Time = 5
	})

	local Window = OrionLib:MakeWindow({
		Name = "SwebHub",
		HidePremium = true,
		SaveConfig = true,
		ConfigFolder = "SwebHubConfigs"
	})

	-- Player Tab
	local PlayerTab = Window:MakeTab({
		Name = "Player",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	local PlayerSection = PlayerTab:AddSection({Name = "Player Settings"})

	PlayerSection:AddSlider({
		Name = "Walkspeed",
		Min = 16,
		Max = 100,
		Default = 16,
		Color = Color3.fromRGB(0, 170, 255),
		Increment = 1,
		ValueName = "Walkspeed",
		Callback = function(Value)
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
		end    
	})

	-- Settings Tab
	local SettingsTab = Window:MakeTab({
		Name = "Settings",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	local SettingsSection = SettingsTab:AddSection({Name = "Settings"})

	SettingsSection:AddButton({
		Name = "Destroy UI",
		Callback = function()
			OrionLib:Destroy()
		end    
	})

	OrionLib:Init()
end
