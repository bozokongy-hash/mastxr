-- Key System
local KEY = "SWEB123" -- change this to your key
local UserInput = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("KeyPrompt")

-- Simple Key Input (uses Roblox Gui)
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local TextButton = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 200)
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, -20, 0, 50)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.Text = "Enter Key to Access Menu"
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
		loadGUI() -- load your menu function
	else
		TextLabel.Text = "Incorrect Key! Try Again."
	end
end)

-- Function to Load Rebranded GUI
function loadGUI()
	local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))() 

	local Window = OrionLib:MakeWindow({
		Name = "SwebHub v2", 
		HidePremium = true, 
		SaveConfig = true, 
		ConfigFolder = "SwebHubConfigs"
	})

	local Tab = Window:MakeTab({
		Name = "Main",
		Icon = "rbxassetid://4483345998",
		PremiumOnly = false
	})

	Tab:AddButton({
		Name = "Test Button",
		Callback = function()
			print("Button Pressed!")
		end    
	})

	Tab:AddToggle({
		Name = "Example Toggle",
		Default = false,
		Callback = function(Value)
			print("Toggle:", Value)
		end    
	})

	Tab:AddSlider({
		Name = "Speed",
		Min = 16,
		Max = 200,
		Default = 16,
		Color = Color3.fromRGB(0,170,255),
		Increment = 1,
		ValueName = "Speed",
		Callback = function(Value)
			print("Slider:", Value)
		end    
	})

	Tab:AddTextbox({
		Name = "Custom Input",
		Default = "Type here",
		TextDisappear = true,
		Callback = function(Value)
			print("Textbox:", Value)
		end	  
	})

	OrionLib:Init()
end
