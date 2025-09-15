-- Load Ash-Libs
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

GUI:CreateMain({
    Name = "MASTXR Hub",
    title = "Musical Chairs Hub",
    ToggleUI = "K",
    Theme = {
        Background = Color3.fromRGB(30,30,35),     -- Dark base
        Secondary = Color3.fromRGB(45,45,50),      -- Slightly lighter panels
        Accent = Color3.fromRGB(0, 170, 255),      -- Bright accent like Rayfield
        Text = Color3.fromRGB(255,255,255),        -- Main text
        TextSecondary = Color3.fromRGB(180,180,180), -- Secondary text
        Border = Color3.fromRGB(30,30,35),         -- Same as background to remove shadow
        NavBackground = Color3.fromRGB(25,25,30)   -- Navigation bar background
    },
    Blur = { Enable = false } -- Remove shadow/blur
})

-- Main Tab
local main = GUI:CreateTab("Main", "home")

-- Auto Sit Toggle
local autoEnabled = false
local autoLoop
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getTargetChair()
    local spinner = workspace:FindFirstChild("SpinnerStuff")
    if spinner and spinner:FindFirstChild("ChairSpots") then
        for _, spot in pairs(spinner.ChairSpots:GetChildren()) do
            if spot:FindFirstChild("ChairParts") and spot.ChairParts:FindFirstChild("Cushion") then
                local cushion = spot.ChairParts.Cushion
                if cushion and not cushion.Occupant then
                    return cushion
                end
            end
        end
    end
    return nil
end

local function smoothTeleport(targetPos)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CFrame = CFrame.new(targetPos + Vector3.new(0,5,0))
end

GUI:CreateToggle({
    parent = main,
    text = "Auto Sit",
    default = false,
    callback = function(state)
        autoEnabled = state
        if autoEnabled then
            autoLoop = task.spawn(function()
                while autoEnabled do
                    local target = getTargetChair()
                    if target then
                        smoothTeleport(target.Position)
                    end
                    task.wait(0.7)
                end
            end)
        else
            if autoLoop then task.cancel(autoLoop) end
        end
    end
})

-- WalkSpeed Slider
local currentSpeed = 16
GUI:CreateSlider({
    parent = main,
    text = "WalkSpeed",
    min = 16,
    max = 100,
    default = 16,
    function(value)
        currentSpeed = value
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = currentSpeed
        end
    end
})

-- Anti-Kick Button
GUI:CreateButton({
    parent = main,
    text = "Enable Anti-Kick",
    callback = function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt,false)
        mt.__namecall = newcclosure(function(self,...)
            local method = getnamecallmethod()
            if method == "Kick" then return nil end
            return oldNamecall(self,...)
        end)
        setreadonly(mt,true)
        GUI:CreateNotify({title = "Anti-Kick", description = "Anti-Kick Enabled!"})
    end
})

-- Notification Example
GUI:CreateButton({
    parent = main,
    text = "Notify Example",
    callback = function()
        GUI:CreateNotify({title = "MASTXR Hub", description = "Welcome to the Rayfield-style Ash-Libs GUI!"})
    end
})
