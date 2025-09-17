-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Key and Discord link
local REQUIRED_KEY = "sweb123"
local discordLink = "https://discord.gg/s2QBMdTF6G"

-- ===== Show notification on execute =====
pcall(function() if setclipboard then setclipboard(discordLink) end end)
Fluent:Notify({
    Title = "MASTXR Hub",
    Content = "Discord link copied (KEY)",
    SubContent = discordLink,
    Duration = 6
})

-- ===== Main GUI =====
local Window = Fluent:CreateWindow({
    Title = "MASTXR Hub " .. Fluent.Version,
    SubTitle = "by @4503 / @bc_ieef",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    StealBrainrot = Window:AddTab({ Title = "Steal Brainrot", Icon = "cpu" }),
    Rivals        = Window:AddTab({ Title = "Rivals", Icon = "swords" }),
    Hypershot     = Window:AddTab({ Title = "Hypershot", Icon = "crosshair" }),
    MusicalChairs = Window:AddTab({ Title = "Musical Chairs", Icon = "shield" }),
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Initially lock all tabs
for _, tab in pairs(Tabs) do
    tab:SetDisabled(true)
end

-- ===== Key Input GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyInputGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 150)
Frame.Position = UDim2.new(0.5, -175, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.Parent = ScreenGui
local UICornerFrame = Instance.new("UICorner")
UICornerFrame.CornerRadius = UDim.new(0,10)
UICornerFrame.Parent = Frame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, -20, 0, 40)
Label.Position = UDim2.new(0,10,0,10)
Label.BackgroundTransparency = 1
Label.Text = "Enter Key to Unlock Menu"
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.TextScaled = true
Label.Font = Enum.Font.Gotham
Label.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0,10,0,60)
TextBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.PlaceholderText = "Enter key here..."
TextBox.Font = Enum.Font.Gotham
TextBox.TextScaled = true
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame
local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0,8)
TextBoxCorner.Parent = TextBox

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.5, 0, 0, 35)
Button.Position = UDim2.new(0.25,0,1,-45)
Button.BackgroundColor3 = Color3.fromRGB(70,70,70)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Text = "Submit"
Button.Font = Enum.Font.Gotham
Button.TextScaled = true
Button.Parent = Frame
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0,8)
ButtonCorner.Parent = Button

-- ===== Button functionality =====
Button.MouseButton1Click:Connect(function()
    local input = TextBox.Text
    if input == REQUIRED_KEY then
        -- Copy Discord link again and notify
        pcall(function() if setclipboard then setclipboard(discordLink) end end)
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = "Discord link copied (KEY)",
            SubContent = discordLink,
            Duration = 6
        })
        -- Unlock all tabs
        for _, tab in pairs(Tabs) do
            tab:SetDisabled(false)
        end
        -- Destroy key GUI
        ScreenGui:Destroy()
        -- Select first tab
        Window:SelectTab(1)
    else
        Fluent:Notify({
            Title = "MASTXR Hub",
            Content = "Invalid Key!",
            Duration = 3
        })
    end
end)

-- ===== Helper for "Coming Soon" =====
local function ComingSoon(title)
    return function()
        Fluent:Notify({ Title = "MASTXR Hub", Content = title .. " is coming soon!", Duration = 4 })
    end
end

-- ===== Steal Brainrot Tab =====
Tabs.StealBrainrot:AddButton({
    Title = "Steal A Brainrot Script",
    Description = "Main Script",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/KaspikScriptsRb/steal-a-brainrot/refs/heads/main/.lua'))()
        Window:Destroy()
    end
})
Tabs.StealBrainrot:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Steal Brainrot Script 2") })

-- ===== Rivals Tab =====
Tabs.Rivals:AddButton({
    Title = "ZYPHERION Rivals Script",
    Description = "Rivals - Main Script",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/blackowl1231/ZYPHERION/refs/heads/main/main.lua'))()
        Window:Destroy()
    end
})
Tabs.Rivals:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Rivals Script 2") })

-- ===== Hypershot Tab =====
Tabs.Hypershot:AddButton({
    Title = "Zephyr Hypershot Script",
    Description = "Hypershot - Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealAvrwm/Zephyr-V2/refs/heads/main/Hypershot.lua", true))()
        Window:Destroy()
    end
})
Tabs.Hypershot:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Hypershot Script 2") })

-- ===== Musical Chairs Tab =====
Tabs.MusicalChairs:AddButton({
    Title = "Ieef Script",
    Description = "Musical Chairs - Main Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bozokongy-hash/mastxr/refs/heads/main/ieefcreation.lua"))()
        Window:Destroy()
    end
})
Tabs.MusicalChairs:AddButton({ Title = "Script 2", Description = "Coming Soon", Callback = ComingSoon("Musical Chairs Script 2") })

-- ===== Settings Tab =====
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MASTXRHub")
SaveManager:SetFolder("MASTXRHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Discord button
Tabs.Settings:AddButton({
    Title = "Join our Discord",
    Icon = "discord",
    Description = "Click to copy the invite",
    Callback = function()
        pcall(function() if setclipboard then setclipboard(discordLink) end end)
        Fluent:Notify({ Title = "MASTXR Hub", Content = "Discord invite copied to clipboard!", SubContent = discordLink, Duration = 6 })
    end
})

Fluent:Notify({ Title = "MASTXR Hub", Content = "The script hub has been loaded!", Duration = 8 })
SaveManager:LoadAutoloadConfig()
