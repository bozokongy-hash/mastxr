-- Scope HUB FULL SCRIPT (Modified: single Billboard ESP with name+distance, robust refresh)
-- Features preserved: Home, Players, Settings, Admin, THEMES tab, SINGLE ESP (BillboardGui name+distance), Bring All, Infinite Jump, Aimbot
-- GUI toggle: RightControl
-- Aimbot integrated (right-click to aim, smooth lerp). ESP shows name + distance above heads via BillboardGui.

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- Admin IDs (example)
local adminIDs = {9479860406}

-- GUI Cleanup (previous instances)
if CoreGui:FindFirstChild("ScopeHub_GUI") then
    CoreGui:FindFirstChild("ScopeHub_GUI"):Destroy()
end
if CoreGui:FindFirstChild("ScopeHub_KeySystem") then
    CoreGui:FindFirstChild("ScopeHub_KeySystem"):Destroy()
end

-- Helper create function (single definition)
local function create(class, props)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then
                obj.Parent = v
            else
                pcall(function() obj[k] = v end)
            end
        end
    end
    return obj
end

-- Helper: is admin
local function isAdmin(plr)
    for _, id in ipairs(adminIDs) do
        if plr.UserId == id then return true end
    end
    return false
end

-- ===========================
-- Theme Library (used for key GUI and main GUI)
-- ===========================
local Themes = {
    DarkRed = {
        Name = "DarkRed",
        Background = Color3.fromRGB(25, 0, 0),
        Title = Color3.fromRGB(40, 0, 0),
        Accent = Color3.fromRGB(150, 0, 0),
        Panel = Color3.fromRGB(28,28,30),
        Text = Color3.fromRGB(255, 230, 230),
        Font = Enum.Font.GothamBold,
    },
    DarkBlue = {
        Name = "DarkBlue",
        Background = Color3.fromRGB(0, 10, 25),
        Title = Color3.fromRGB(0, 20, 40),
        Accent = Color3.fromRGB(0, 100, 200),
        Panel = Color3.fromRGB(18,18,20),
        Text = Color3.fromRGB(230, 240, 255),
        Font = Enum.Font.GothamBold,
    },
    DarkGreen = {
        Name = "DarkGreen",
        Background = Color3.fromRGB(0, 25, 10),
        Title = Color3.fromRGB(0, 40, 20),
        Accent = Color3.fromRGB(0, 200, 100),
        Panel = Color3.fromRGB(18,18,20),
        Text = Color3.fromRGB(230, 255, 240),
        Font = Enum.Font.GothamBold,
    },
    Light = {
        Name = "Light",
        Background = Color3.fromRGB(240, 240, 240),
        Title = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(100, 150, 255),
        Panel = Color3.fromRGB(230,230,230),
        Text = Color3.fromRGB(20, 20, 20),
        Font = Enum.Font.GothamSemibold,
    },
    Monochrome = {
        Name = "Monochrome",
        Background = Color3.fromRGB(30, 30, 30),
        Title = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(100, 100, 100),
        Panel = Color3.fromRGB(28,28,28),
        Text = Color3.fromRGB(230, 230, 230),
        Font = Enum.Font.Gotham,
    },
}

-- Choose default theme name (can be changed at top)
local CurrentThemeName = "DarkRed"
local CurrentTheme = Themes[CurrentThemeName] or Themes.DarkRed

-- ===========================
-- KEY SYSTEM GUI (shows first, uses theme)
-- ===========================
local correctKey = "scope91"
local discordLink = "https://discord.gg/Q9caeDr2M8"
local keyVerified = false

local keyGui = create("ScreenGui", {
    Name = "ScopeHub_KeySystem",
    ResetOnSpawn = false,
    Parent = CoreGui,
})

local keyFrame = create("Frame", {
    Parent = keyGui,
    Size = UDim2.new(0,350,0,180),
    Position = UDim2.new(0.5,-175,0.5,-90),
    BackgroundColor3 = CurrentTheme.Panel,
    BorderSizePixel = 0,
})
keyFrame.Active = true
keyFrame.Draggable = true

create("TextLabel", {
    Parent = keyFrame,
    Size = UDim2.new(1,-20,0,40),
    Position = UDim2.new(0,10,0,10),
    BackgroundTransparency = 1,
    Text = "Scope HUB - Key System",
    TextColor3 = CurrentTheme.Text,
    Font = CurrentTheme.Font,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Center,
})

local keyBox = create("TextBox", {
    Parent = keyFrame,
    Size = UDim2.new(0,200,0,30),
    Position = UDim2.new(0.5,-100,0,60),
    PlaceholderText = "Enter your key...",
    Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(0,0,0), -- typed text is black
    BackgroundColor3 = Color3.fromRGB(255,255,255),
    PlaceholderColor3 = Color3.fromRGB(100,100,100) -- dark gray placeholder
})
local verifyBtn = create("TextButton", {
    Parent = keyFrame,
    Size = UDim2.new(0,100,0,30),
    Position = UDim2.new(0.5,-50,0,100),
    Text = "Verify",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Accent,
    BorderSizePixel = 0,
})
local discordBtn = create("TextButton", {
    Parent = keyFrame,
    Size = UDim2.new(0,200,0,30),
    Position = UDim2.new(0.5,-100,0,140),
    Text = "Copy Discord Link",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Accent,
    BorderSizePixel = 0,
})
discordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(discordLink) end)
end)
verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == correctKey then
        keyVerified = true
        keyGui:Destroy()
        print("Key verified! Loading Scope HUB...")
    else
        verifyBtn.Text = "Invalid Key!"
        wait(1)
        verifyBtn.Text = "Verify"
    end
end)

-- Wait for key verification before continuing
while not keyVerified do
    wait()
end

-- ===========================
-- Aimbot (from Sn!pe Hub) - integrated
-- ===========================
local AimbotEnabled = false
local aiming = false
local AimSpeed = 0.30 -- default smoothness (0..1)
local AimbotPart = "HumanoidRootPart" -- which part to aim at
local Camera = workspace.CurrentCamera

-- MAX distance for aimbot (100 studs)
local MAX_AIM_DISTANCE = 100

-- Replacement for getClosestPlayerToCenter(): only players within MAX_AIM_DISTANCE are considered
local function getClosestPlayerToCenter()
    local closestPlayer = nil
    local shortestDistance = math.huge
    if not Camera then Camera = workspace.CurrentCamera end
    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotPart) then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local part = player.Character[AimbotPart]
            -- ensure we have humanoid and part, and local player's HRP exists
            if humanoid and humanoid.Health > 0 and part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local worldDist = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if worldDist <= MAX_AIM_DISTANCE then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function aimAtPosition(targetPos)
    if not targetPos then return end
    if not Camera then Camera = workspace.CurrentCamera end
    local cameraCFrame = Camera.CFrame
    local direction = (targetPos - cameraCFrame.Position).Unit
    local newCFrame = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + direction)
    Camera.CFrame = cameraCFrame:Lerp(newCFrame, math.clamp(AimSpeed, 0, 1))
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end
end)

local function onCharacterAdded(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.Died:Connect(function() aiming = false end)
    end
end
LocalPlayer.CharacterAdded:Connect(function(c) onCharacterAdded(c) end)
if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end

-- ===========================
-- Main GUI
-- ===========================
local screenGui = create("ScreenGui", {
    Name = "ScopeHub_GUI",
    ResetOnSpawn = false,
    Parent = CoreGui,
})

local main = create("Frame", {
    Name = "Main",
    Parent = screenGui,
    Size = UDim2.new(0,525,0,420),
    Position = UDim2.new(0.5,-262,0.5,-210),
    BackgroundColor3 = CurrentTheme.Background,
    BorderSizePixel = 0,
})
main.Active = true
main.Draggable = true

local title = create("Frame", {
    Name = "TitleBar",
    Parent = main,
    Size = UDim2.new(1,0,0,36),
    BackgroundColor3 = CurrentTheme.Title,
    BorderSizePixel = 0,
})

local titleLabel = create("TextLabel", {
    Parent = title,
    Size = UDim2.new(1,-10,1,0),
    Position = UDim2.new(0,10,0,0),
    BackgroundTransparency = 1,
    Text = "Scope HUB | Sweb / @4503",
    TextColor3 = CurrentTheme.Text,
    Font = CurrentTheme.Font,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Tabs
local tabsFrame = create("Frame", {
    Parent = main,
    Size = UDim2.new(0,120,1,-36),
    Position = UDim2.new(0,0,0,36),
    BackgroundTransparency = 1,
})

local function makeTabButton(name, y)
    local btn = create("TextButton", {
        Parent = tabsFrame,
        Size = UDim2.new(1,0,0,36),
        Position = UDim2.new(0,0,0,y),
        BackgroundColor3 = CurrentTheme.Panel,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
    })
    return btn
end

local pages = {}
local function makePage(name)
    local page = create("Frame", {
        Parent = main,
        Size = UDim2.new(1,-120,1,-36),
        Position = UDim2.new(0,120,0,36),
        BackgroundTransparency = 1,
        Visible = false,
        Name = name.."_Page",
    })
    pages[name] = page
    return page
end

local homeBtn = makeTabButton("Home",8)
local playersBtn = makeTabButton("Players",44)
local settingsBtn = makeTabButton("Settings",80)
local adminBtn = makeTabButton("Admin",116)
local themesBtn = makeTabButton("Themes",152) -- new Themes tab

local homePage = makePage("Home")
local playersPage = makePage("Players")
local settingsPage = makePage("Settings")
local adminPage = makePage("Admin")
local themesPage = makePage("Themes") -- page for themes

local function showPage(name)
    for k, v in pairs(pages) do v.Visible = false end
    if pages[name] then pages[name].Visible = true end
end
showPage("Home")
homeBtn.MouseButton1Click:Connect(function() showPage("Home") end)
playersBtn.MouseButton1Click:Connect(function() showPage("Players") end)
settingsBtn.MouseButton1Click:Connect(function() showPage("Settings") end)
adminBtn.MouseButton1Click:Connect(function()
    if isAdmin(LocalPlayer) then showPage("Admin") else
        local old = adminBtn.Text
        adminBtn.Text = "LOCKED"
        wait(1)
        adminBtn.Text = old
    end
end)
themesBtn.MouseButton1Click:Connect(function() showPage("Themes") end)

-- HOME page
create("TextLabel", {
    Parent = homePage,
    Size = UDim2.new(1,-24,0,24),
    Position = UDim2.new(0,12,0,12),
    BackgroundTransparency = 1,
    Text = "Welcome to Scope HUB",
    TextColor3 = CurrentTheme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})
create("TextLabel", {
    Parent = homePage,
    Size = UDim2.new(1,-24,0,80),
    Position = UDim2.new(0,12,0,44),
    BackgroundTransparency = 1,
    Text = "Credits: Sweb / @4503 | Aimbot toggle (hold) RMB !ONLY LOCKS ON WITHIN 100 STUDS! | Menu toggle RightCtrl",
    TextColor3 = Color3.fromRGB(180,180,180),
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
})

-- PLAYERS page
local playerSearch = create("TextBox", {
    Parent = playersPage,
    Size = UDim2.new(1,-24,0,28),
    Position = UDim2.new(0,12,0,12),
    PlaceholderText = "Search player...",
    Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})
local refreshBtn = create("TextButton", {
    Parent = playersPage,
    Size = UDim2.new(0,100,0,28),
    Position = UDim2.new(1,-112,0,12),
    Text = "Refresh",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Accent,
    TextColor3 = CurrentTheme.Text,
})
local playersList = create("ScrollingFrame", {
    Parent = playersPage,
    Size = UDim2.new(1,-24,1,-56),
    Position = UDim2.new(0,12,0,48),
    BackgroundColor3 = CurrentTheme.Panel,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0,0,0,0),
})
playersList.ScrollBarThickness = 6
local uiListLayout = create("UIListLayout", { Parent = playersList })
uiListLayout.Padding = UDim.new(0,6)

local function makePlayerRow(plr)
    local row = create("Frame", {
        Parent = playersList,
        Size = UDim2.new(1,-12,0,46),
        BackgroundColor3 = CurrentTheme.Panel,
        BorderSizePixel = 0,
    })
    create("TextLabel", {
        Parent = row,
        Size = UDim2.new(0.6,-8,1,0),
        Position = UDim2.new(0,6,0,0),
        BackgroundTransparency = 1,
        Text = plr.Name.." ["..plr.UserId.."]",
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local btnContainer = create("Frame", {
        Parent = row,
        Size = UDim2.new(0.4,-8,1,-8),
        Position = UDim2.new(0.6,2,0,4),
        BackgroundTransparency = 1,
    })
    local teleportBtn = create("TextButton", {
        Parent = btnContainer,
        Size = UDim2.new(0.33,-4,1,0),
        Position = UDim2.new(0,0,0,0),
        Text = "TP",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundColor3 = CurrentTheme.Accent,
        TextColor3 = CurrentTheme.Text,
    })
    local spectateBtn = create("TextButton", {
        Parent = btnContainer,
        Size = UDim2.new(0.33,-4,1,0),
        Position = UDim2.new(0.33,3,0,0),
        Text = "Spec",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundColor3 = CurrentTheme.Accent,
        TextColor3 = CurrentTheme.Text,
    })
    local copyBtn = create("TextButton", {
        Parent = btnContainer,
        Size = UDim2.new(0.34,-4,1,0),
        Position = UDim2.new(0.66,6,0,0),
        Text = "ID",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundColor3 = CurrentTheme.Accent,
        TextColor3 = CurrentTheme.Text,
    })
    teleportBtn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end)
    spectateBtn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = plr.Character:FindFirstChildWhichIsA("Humanoid")
        end
    end)
    copyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(tostring(plr.UserId)) end)
    end)
end

local function refreshPlayers()
    for _, v in pairs(playersList:GetChildren()) do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
    local search = playerSearch.Text:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if search == "" or plr.Name:lower():find(search) then
                makePlayerRow(plr)
            end
        end
    end
    playersList.CanvasSize = UDim2.new(0,0,0,uiListLayout.AbsoluteContentSize.Y+8)
end

refreshBtn.MouseButton1Click:Connect(refreshPlayers)
playerSearch:GetPropertyChangedSignal("Text"):Connect(refreshPlayers)
Players.PlayerAdded:Connect(function() wait(0.2) refreshPlayers() end)
Players.PlayerRemoving:Connect(function() wait(0.2) refreshPlayers() end)
refreshPlayers()

-- ===========================
-- SETTINGS page
-- ===========================
create("TextLabel", {
    Parent = settingsPage,
    Size = UDim2.new(1,-24,0,24),
    Position = UDim2.new(0,12,0,12),
    BackgroundTransparency = 1,
    Text = "Visuals & Player Options",
    TextColor3 = CurrentTheme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- ===========================
-- SINGLE Billboard ESP (name + distance) - simplified and robust
-- ===========================
local espEnabled = false
local espDistance = 200
local espToggle = create("TextButton", {
    Parent = settingsPage,
    Size = UDim2.new(0,140,0,30),
    Position = UDim2.new(0,12,0,48),
    Text = "ESP: OFF",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Accent,
    TextColor3 = CurrentTheme.Text,
})
local espDistBox = create("TextBox", {
    Parent = settingsPage,
    Size = UDim2.new(0,120,0,30),
    Position = UDim2.new(0,162,0,48),
    Text = tostring(espDistance),
    PlaceholderText = "Max Dist",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})

-- Map to store billboards per player
local espMap = {}

-- Create a billboard for a player's character (attached to Head if available, otherwise HumanoidRootPart)
local function createESPForPlayer(plr)
    if not plr or espMap[plr] then return end
    -- ensure they have a character with a root part - we'll attach when we can
    local bill = create("BillboardGui", {
        Name = "Scope_ESP",
        Size = UDim2.new(0,140,0,40),
        Adornee = nil,
        AlwaysOnTop = true,
        ResetOnSpawn = false,
        Parent = plr.Character or workspace,
    })
    local frame = create("Frame", {
        Parent = bill,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 0.25,
        BackgroundColor3 = CurrentTheme.Panel,
        BorderSizePixel = 0,
    })
    local nameLabel = create("TextLabel", {
        Parent = frame,
        Size = UDim2.new(1,0,0,20),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        Text = plr.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = CurrentTheme.Text,
    })
    local distLabel = create("TextLabel", {
        Parent = frame,
        Size = UDim2.new(1,0,0,18),
        Position = UDim2.new(0,0,0,20),
        BackgroundTransparency = 1,
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = CurrentTheme.Text,
    })
    espMap[plr] = {
        Bill = bill,
        Frame = frame,
        NameLabel = nameLabel,
        DistLabel = distLabel,
    }
    -- attempt to attach to character if present
    if plr.Character and plr.Character.Parent then
        local adorn = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
        if adorn then
            espMap[plr].Bill.Adornee = adorn
            espMap[plr].Bill.Parent = plr.Character
        end
    end
end

local function removeESPForPlayer(plr)
    local data = espMap[plr]
    if data and data.Bill then
        pcall(function() data.Bill:Destroy() end)
    end
    espMap[plr] = nil
end

Players.PlayerRemoving:Connect(function(plr)
    removeESPForPlayer(plr)
end)

-- Toggle logic
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    pcall(function() espToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0,150,0) or CurrentTheme.Accent end)
    if not espEnabled then
        -- destroy all billboards
        for plr,_ in pairs(espMap) do removeESPForPlayer(plr) end
    else
        -- create billboards for all current players (except local)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                createESPForPlayer(plr)
            end
        end
    end
end)

espDistBox.FocusLost:Connect(function()
    local val = tonumber(espDistBox.Text)
    if val then espDistance = val else espDistBox.Text = tostring(espDistance) end
end)

local function onCharacterSpawnedForPlayer(plr, char)
    removeESPForPlayer(plr)
    if espEnabled and plr ~= LocalPlayer then
        createESPForPlayer(plr)
        local entry = espMap[plr]
        if entry and entry.Bill and plr.Character then
            local adorn = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
            if adorn then
                entry.Bill.Adornee = adorn
                entry.Bill.Parent = plr.Character
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        onCharacterSpawnedForPlayer(plr, char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                removeESPForPlayer(plr)
            end)
        end
    end)
    if plr.Character then
        onCharacterSpawnedForPlayer(plr, plr.Character)
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Died:Connect(function() removeESPForPlayer(plr) end) end
    end
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        if plr.Character then
            onCharacterSpawnedForPlayer(plr, plr.Character)
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Died:Connect(function() removeESPForPlayer(plr) end) end
        end
        plr.CharacterAdded:Connect(function(char)
            onCharacterSpawnedForPlayer(plr, char)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Died:Connect(function() removeESPForPlayer(plr) end) end
        end)
    end
end

-- Update loop for billboards (position/distance/visibility)
RunService.RenderStepped:Connect(function()
    if espEnabled then
        local maxDist = tonumber(espDistBox.Text) or espDistance
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local data = espMap[plr]
                if plr.Character and plr.Character.Parent and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not data then
                        createESPForPlayer(plr)
                        data = espMap[plr]
                    end
                    if data and data.Bill then
                        if not data.Bill.Adornee then
                            data.Bill.Adornee = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
                            data.Bill.Parent = plr.Character
                        end
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            data.DistLabel.Text = "Dist: "..tostring(dist)
                            data.NameLabel.Text = plr.Name
                            data.Bill.Enabled = dist <= maxDist
                        else
                            data.Bill.Enabled = false
                        end
                    end
                else
                    removeESPForPlayer(plr)
                end
            end
        end
    end
end)

-- ===========================
-- Bring All
-- ===========================
local bringAllBtn = create("TextButton", {
    Parent = settingsPage,
    Size = UDim2.new(0,120,0,30),
    Position = UDim2.new(0,12,0,88),
    Text = "Bring All",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Accent,
    TextColor3 = CurrentTheme.Text,
})
local bringAllEnabled = false
bringAllBtn.MouseButton1Click:Connect(function()
    bringAllEnabled = not bringAllEnabled
    bringAllBtn.Text = bringAllEnabled and "Bring All: ON" or "Bring All: OFF"
end)
RunService.RenderStepped:Connect(function()
    if bringAllEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local cf = LocalPlayer.Character.HumanoidRootPart.CFrame
        local frontPos = cf.Position + cf.LookVector * 15
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(frontPos)
                end)
            end
        end
    end
end)

-- ===========================
-- Walk Speed
-- ===========================
local walkSpeedEnabled = false
local desiredWalkSpeed = 16 -- default shown in box
local prevWalkSpeed = nil

local walkSpeedToggle = create("TextButton", {
    Parent = settingsPage,
    Size = UDim2.new(0,160,0,30),
    Position = UDim2.new(0,12,0,168),
    Text = "Walk Speed: OFF",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Accent,
    BorderSizePixel = 0,
})
local walkSpeedBox = create("TextBox", {
    Parent = settingsPage,
    Size = UDim2.new(0,120,0,28),
    Position = UDim2.new(0,184,0,170),
    Text = tostring(desiredWalkSpeed),
    PlaceholderText = "Speed (number)",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})

local function applyWalkSpeedToHumanoid(hum)
    if not hum then return end
    if walkSpeedEnabled then
        if prevWalkSpeed == nil then
            prevWalkSpeed = hum.WalkSpeed
        end
        pcall(function()
            hum.WalkSpeed = tonumber(desiredWalkSpeed) or hum.WalkSpeed
        end)
    else
        if prevWalkSpeed then
            pcall(function() hum.WalkSpeed = prevWalkSpeed end)
        end
    end
end

walkSpeedToggle.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled
    walkSpeedToggle.Text = "Walk Speed: " .. (walkSpeedEnabled and "ON" or "OFF")
    pcall(function() walkSpeedToggle.BackgroundColor3 = walkSpeedEnabled and Color3.fromRGB(0,150,0) or CurrentTheme.Accent end)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            applyWalkSpeedToHumanoid(hum)
        end
    end
    if not walkSpeedEnabled then
        prevWalkSpeed = nil
    end
end)

walkSpeedBox.FocusLost:Connect(function()
    local val = tonumber(walkSpeedBox.Text)
    if val and val > 0 then
        desiredWalkSpeed = val
    else
        walkSpeedBox.Text = tostring(desiredWalkSpeed)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if walkSpeedEnabled then
            if prevWalkSpeed == nil then
                prevWalkSpeed = hum.WalkSpeed
            end
            pcall(function() hum.WalkSpeed = tonumber(desiredWalkSpeed) or hum.WalkSpeed end)
        end
        hum.Died:Connect(function()
            -- keep prevWalkSpeed state
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    if walkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character.Parent then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.WalkSpeed = tonumber(desiredWalkSpeed) or hum.WalkSpeed end)
        end
    end
end)

-- ===========================
-- Aimbot UI Controls
-- ===========================
local aimbotToggle = create("TextButton", {
    Parent = settingsPage,
    Size = UDim2.new(0,160,0,30),
    Position = UDim2.new(0,12,0,128),
    Text = "Aimbot: OFF",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Accent,
    BorderSizePixel = 0,
})
local aimPartBox = create("TextBox", {
    Parent = settingsPage,
    Size = UDim2.new(0,120,0,28),
    Position = UDim2.new(0,184,0,128),
    Text = AimbotPart,
    PlaceholderText = "Part (e.g. Head)",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})
local aimSpeedBox = create("TextBox", {
    Parent = settingsPage,
    Size = UDim2.new(0,120,0,28),
    Position = UDim2.new(0,312,0,128),
    Text = tostring(AimSpeed),
    PlaceholderText = "AimSpeed (0-1)",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})
aimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    aimbotToggle.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
    pcall(function() aimbotToggle.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0,150,0) or CurrentTheme.Accent end)
end)
aimPartBox.FocusLost:Connect(function()
    local txt = aimPartBox.Text or ""
    if txt ~= "" then AimbotPart = txt else aimPartBox.Text = AimbotPart end
end)
aimSpeedBox.FocusLost:Connect(function()
    local val = tonumber(aimSpeedBox.Text)
    if val and val >= 0 and val <= 1 then AimSpeed = val else aimSpeedBox.Text = tostring(AimSpeed) end
end)

-- ===========================
-- ADMIN PAGE
-- ===========================
create("TextLabel", {
    Parent = adminPage,
    Size = UDim2.new(1,-24,0,24),
    Position = UDim2.new(0,12,0,12),
    BackgroundTransparency = 1,
    Text = "Admin Management",
    TextColor3 = CurrentTheme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})
local adminInput = create("TextBox", {
    Parent = adminPage,
    Size = UDim2.new(0,200,0,28),
    Position = UDim2.new(0,12,0,48),
    PlaceholderText = "Enter UserId...",
    Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})
local addAdminBtn = create("TextButton", {
    Parent = adminPage,
    Size = UDim2.new(0,100,0,28),
    Position = UDim2.new(0,220,0,48),
    Text = "Add Admin",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Accent,
    TextColor3 = CurrentTheme.Text,
})
local adminListFrame = create("ScrollingFrame", {
    Parent = adminPage,
    Size = UDim2.new(1,-24,1,-88),
    Position = UDim2.new(0,12,0,88),
    BackgroundColor3 = CurrentTheme.Panel,
    BorderSizePixel = 0,
})
adminListFrame.ScrollBarThickness = 6
local adminListLayout = create("UIListLayout", { Parent = adminListFrame })
adminListLayout.Padding = UDim.new(0,4)

local function refreshAdminList()
    for _, child in pairs(adminListFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, id in ipairs(adminIDs) do
        local row = create("Frame", {
            Parent = adminListFrame,
            Size = UDim2.new(1,-8,0,28),
            BackgroundColor3 = CurrentTheme.Panel,
            BorderSizePixel = 0,
        })
        create("TextLabel", {
            Parent = row,
            Size = UDim2.new(0.7,0,1,0),
            BackgroundTransparency = 1,
            Text = tostring(id),
            TextColor3 = CurrentTheme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0,4,0,0),
        })
        local removeBtn = create("TextButton", {
            Parent = row,
            Size = UDim2.new(0.3,-4,1,0),
            Position = UDim2.new(0.7,4,0,0),
            Text = "Remove",
            Font = Enum.Font.Gotham,
            TextSize = 12,
            BackgroundColor3 = CurrentTheme.Accent,
            TextColor3 = CurrentTheme.Text,
        })
        removeBtn.MouseButton1Click:Connect(function()
            table.remove(adminIDs, i)
            refreshAdminList()
        end)
    end
    adminListFrame.CanvasSize = UDim2.new(0,0,0,adminListLayout.AbsoluteContentSize.Y+4)
end

addAdminBtn.MouseButton1Click:Connect(function()
    local id = tonumber(adminInput.Text)
    if id and not table.find(adminIDs, id) then
        table.insert(adminIDs, id)
        adminInput.Text = ""
        refreshAdminList()
    end
end)
refreshAdminList()

-- GUI Toggle (RightControl)
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

-- ===========================
-- Aimbot Main Loop
-- ===========================
RunService.RenderStepped:Connect(function()
    if AimbotEnabled and aiming then
        local targetPlayer = getClosestPlayerToCenter()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(AimbotPart) then
            local targetPart = targetPlayer.Character[AimbotPart]
            if targetPart and targetPart.Position then
                aimAtPosition(targetPart.Position)
            end
        end
    end
end)

-- ===========================
-- THEMES SYSTEM (UI + applyTheme)
-- ===========================
-- applyTheme updates visual elements to selected theme
local function applyTheme(theme)
    if not theme then return end
    CurrentTheme = theme
    -- main elements
    main.BackgroundColor3 = theme.Background
    title.BackgroundColor3 = theme.Title
    titleLabel.TextColor3 = theme.Text
    titleLabel.Font = theme.Font

    -- iterate descendants and apply reasonable defaults
    for _, obj in pairs(main:GetDescendants()) do
        if obj:IsA("Frame") then
            -- keep main and title untouched; for other frames use Panel color unless transparent
            if obj ~= main and obj ~= title and obj.BackgroundTransparency < 1 then
                pcall(function() obj.BackgroundColor3 = theme.Panel end)
            end
        elseif obj:IsA("TextLabel") then
            if obj.BackgroundTransparency == 1 then
                pcall(function() obj.TextColor3 = theme.Text end)
            else
                pcall(function() obj.TextColor3 = theme.Text end)
            end
        elseif obj:IsA("TextButton") then
            -- buttons use Accent by default (some toggles override themselves later)
            pcall(function()
                obj.TextColor3 = theme.Text
                if obj ~= titleLabel then
                    obj.BackgroundColor3 = theme.Accent
                end
            end)
        elseif obj:IsA("TextBox") then
            pcall(function()
                obj.TextColor3 = theme.Text
                obj.BackgroundColor3 = theme.Panel
            end)
        elseif obj:IsA("ScrollingFrame") then
            pcall(function() obj.BackgroundColor3 = theme.Panel end)
        end
    end

    -- Update billboards (ESP)
    for plr, data in pairs(espMap) do
        pcall(function()
            if data.Frame then data.Frame.BackgroundColor3 = theme.Panel end
            if data.NameLabel then data.NameLabel.TextColor3 = theme.Text end
            if data.DistLabel then data.DistLabel.TextColor3 = theme.Text end
        end)
    end
end

-- build themes UI: buttons for presets + custom fields
local yPos = 12
for themeName, themeData in pairs(Themes) do
    local btn = create("TextButton", {
        Parent = themesPage,
        Size = UDim2.new(0,200,0,32),
        Position = UDim2.new(0,12,0,yPos),
        Text = themeName,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        BackgroundColor3 = themeData.Accent,
        TextColor3 = themeData.Text,
        BorderSizePixel = 0,
    })
    btn.MouseButton1Click:Connect(function()
        applyTheme(themeData)
    end)
    yPos = yPos + 40
end

-- customizer: three boxes for R G B on background + apply button
local customLabel = create("TextLabel", {
    Parent = themesPage,
    Size = UDim2.new(1,-24,0,20),
    Position = UDim2.new(0,12,0,yPos),
    BackgroundTransparency = 1,
    Text = "Custom Background RGB (0-255):",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = CurrentTheme.Text,
})
yPos = yPos + 24
local rBox = create("TextBox", {
    Parent = themesPage,
    Size = UDim2.new(0,60,0,28),
    Position = UDim2.new(0,12,0,yPos),
    Text = tostring(CurrentTheme.Background.R * 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})
local gBox = create("TextBox", {
    Parent = themesPage,
    Size = UDim2.new(0,60,0,28),
    Position = UDim2.new(0,84,0,yPos),
    Text = tostring(CurrentTheme.Background.G * 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})
local bBox = create("TextBox", {
    Parent = themesPage,
    Size = UDim2.new(0,60,0,28),
    Position = UDim2.new(0,156,0,yPos),
    Text = tostring(CurrentTheme.Background.B * 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CurrentTheme.Text,
    BackgroundColor3 = CurrentTheme.Panel,
})
local applyCustomBtn = create("TextButton", {
    Parent = themesPage,
    Size = UDim2.new(0,100,0,28),
    Position = UDim2.new(0,228,0,yPos),
    Text = "Apply",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Accent,
    TextColor3 = CurrentTheme.Text,
})
applyCustomBtn.MouseButton1Click:Connect(function()
    local r = tonumber(rBox.Text); local g = tonumber(gBox.Text); local b = tonumber(bBox.Text)
    if r and g and b then
        local custom = {
            Name = "Custom",
            Background = Color3.fromRGB(math.clamp(math.floor(r),0,255), math.clamp(math.floor(g),0,255), math.clamp(math.floor(b),0,255)),
            Title = Color3.fromRGB(math.clamp(math.floor(r/1.5),0,255), math.clamp(math.floor(g/1.5),0,255), math.clamp(math.floor(b/1.5),0,255)),
            Accent = Color3.fromRGB(math.clamp(math.floor(r*0.6),0,255), math.clamp(math.floor(g*0.6),0,255), math.clamp(math.floor(b*0.6),0,255)),
            Panel = Color3.fromRGB(math.clamp(math.floor(r*0.4),0,255), math.clamp(math.floor(g*0.4),0,255), math.clamp(math.floor(b*0.4),0,255)),
            Text = (r+g+b) / 3 > 128 and Color3.fromRGB(20,20,20) or Color3.fromRGB(230,230,230),
            Font = Enum.Font.Gotham,
        }
        applyTheme(custom)
    end
end)

-- initialize theme on load
applyTheme(CurrentTheme)

-- ===========================
-- Final print
-- ===========================
print("Scope HUB loaded — single Billboard ESP (name+distance) integrated; Themes tab added. All other features preserved. Fly removed.")
