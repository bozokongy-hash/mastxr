-- Roblox Mod Menu GUI (Working Version)
-- Place this as a LocalScript in StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- Theme
local COLORS = {
    background = Color3.fromRGB(15, 15, 15),
    panel = Color3.fromRGB(20, 20, 20),
    border = Color3.fromRGB(46, 46, 46),
    muted = Color3.fromRGB(30, 30, 30),
    text = Color3.fromRGB(245, 245, 245),
    subtle = Color3.fromRGB(160, 160, 160),
    primary = Color3.fromRGB(22, 163, 74),
    accent = Color3.fromRGB(16, 112, 56),
    shadow = Color3.fromRGB(0, 0, 0),
}

-- Utility Functions
local function New(className, props, children)
    local inst = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            inst[k] = v
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

local function setPadding(container, pad)
    New("UIPadding", {
        Parent = container,
        PaddingTop = UDim.new(0, pad),
        PaddingBottom = UDim.new(0, pad),
        PaddingLeft = UDim.new(0, pad),
        PaddingRight = UDim.new(0, pad),
    })
end

local function makeToast(root, text)
    local lbl = New("TextLabel", {
        BackgroundTransparency = 0.15,
        BackgroundColor3 = COLORS.muted,
        TextColor3 = COLORS.text,
        Text = text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 1),
        ZIndex = 50,
    }, {
        New("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
        New("UICorner", { CornerRadius = UDim.new(0, 8) }),
    })
    lbl.Parent = root
    lbl.BackgroundTransparency = 1
    lbl.TextTransparency = 1
    TweenService:Create(lbl, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.15, TextTransparency = 0 }):Play()
    task.delay(1.5, function()
        TweenService:Create(lbl, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
        task.delay(0.26, function() lbl:Destroy() end)
    end)
end

-- State
local State = {
    aimbot = { enabled = false, fov = 60, smooth = 50 },
    visuals = { esp = true, boxes = true, chams = false },
    movement = { fly = false, speed = 16, jump = 50, noclip = false },
    misc = { bhop = false, god = false, autoCollect = false },
}

-- Root GUI
local screen = New("ScreenGui", {
    Name = "RobloxModMenuGUI",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = guiParent,
})

-- Main window
local window = New("Frame", {
    Parent = screen,
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(420, 180),
    Size = UDim2.fromOffset(720, 420),
})
New("UICorner", { Parent = window, CornerRadius = UDim.new(0, 12) })
New("UIStroke", { Parent = window, Thickness = 1, Color = COLORS.border })

-- Header (Draggable)
local header = New("Frame", {
    Parent = window,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 56),
})
New("UICorner", { Parent = header, CornerRadius = UDim.new(0, 12) })
New("UIStroke", { Parent = header, Thickness = 1, Color = COLORS.border })

local headerTitle = New("TextLabel", {
    Parent = header,
    Text = "MOD MENU",
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextColor3 = COLORS.text,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 8),
    Size = UDim2.fromOffset(200, 20),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Drag logic
do
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Tabs
local tabsBar = New("Frame", {
    Parent = window,
    BackgroundColor3 = Color3.fromRGB(26, 26, 26),
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(12, 64),
    Size = UDim2.new(1, -24, 0, 36),
})
New("UICorner", { Parent = tabsBar, CornerRadius = UDim.new(0, 8) })
New("UIStroke", { Parent = tabsBar, Thickness = 1, Color = COLORS.border })
setPadding(tabsBar, 6)
local tabsList = New("UIListLayout", {
    Parent = tabsBar,
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
})

local pagesContainer = New("Frame", {
    Parent = window,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 108),
    Size = UDim2.new(1, -24, 1, -120),
})
local pages = {}
local currentPage = nil

local function selectTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = (tabName == name)
    end
    currentPage = name
end

local function makeTab(name)
    local btn = New("TextButton", {
        Parent = tabsBar,
        AutoButtonColor = false,
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = COLORS.text,
        BackgroundColor3 = Color3.fromRGB(36, 36, 36),
        Size = UDim2.fromOffset(120, 24),
    })
    New("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 6) })
    New("UIStroke", { Parent = btn, Thickness = 1, Color = COLORS.border })

    local page = New("Frame", {
        Parent = pagesContainer,
        Visible = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    })
    pages[name] = page

    btn.MouseButton1Click:Connect(function()
        selectTab(name)
        -- Tween highlight
        TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = COLORS.primary }):Play()
        for _, otherBtn in pairs(tabsBar:GetChildren()) do
            if otherBtn:IsA("TextButton") and otherBtn ~= btn then
                otherBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            end
        end
    end)
    return page
end

-- Example tabs
local aimbotTab = makeTab("Aimbot")
local visualsTab = makeTab("Visuals")
local movementTab = makeTab("Movement")
local miscTab = makeTab("Misc")
selectTab("Aimbot") -- Default tab

-- Example content
local function addLabel(tab, text)
    local lbl = New("TextLabel", {
        Parent = tab,
        Text = text,
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
    })
    return lbl
end

addLabel(aimbotTab, "Aimbot Enabled: "..tostring(State.aimbot.enabled))
addLabel(visualsTab, "ESP: "..tostring(State.visuals.esp))
addLabel(movementTab, "Fly: "..tostring(State.movement.fly))
addLabel(miscTab, "BHop: "..tostring(State.misc.bhop))
