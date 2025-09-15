-- THIS IS A SINGLE LUA SCRIPT TO DEMONSTRATE THE LOGIC.
-- IT IS NOT MEANT TO BE USED AS-IS IN ROBLOX STUDIO.
-- FOR A FUNCTIONAL MOD MENU, YOU MUST SEPARATE THIS INTO A
-- LOCAL SCRIPT AND A SERVER SCRIPT.

--[[
    THIS SECTION IS FOR A SERVER SCRIPT.
    Put this part in ServerScriptService.
]]

-- The `game` service is available to both LocalScripts and ServerScripts.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- The RemoteEvent is the bridge between the client and server.
local checkKeyEvent = Instance.new("RemoteEvent")
checkKeyEvent.Name = "CheckKeyEvent"
checkKeyEvent.Parent = ReplicatedStorage

-- These are your valid keys.
-- NEVER store this list in a LocalScript.
local validKeys = {
    "your_first_key_here",
    "your_second_key_here",
    "another_unique_key"
}

-- This is a function that the server will run when a player tries to check a key.
-- `player` is automatically passed by Roblox.
checkKeyEvent.OnServerEvent:Connect(function(player, enteredKey)
    local isKeyValid = false
    -- Check if the entered key is in our secure list.
    for _, key in ipairs(validKeys) do
        if key == enteredKey then
            isKeyValid = true
            break
        end
    end

    -- Send a response back to the player's client.
    checkKeyEvent:FireClient(player, isKeyValid)
end)

--[[
    THIS SECTION IS FOR A LOCAL SCRIPT.
    Put this part inside your GUI, for example, in the MainFrame.
]]

-- Local scripts can access the local player and the GUI.
local player = Players.LocalPlayer
local screenGui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local mainFrame = screenGui:WaitForChild("MainFrame")
local keySystemFrame = mainFrame:WaitForChild("KeySystemFrame")
local modMenuFrame = mainFrame:WaitForChild("ModMenuFrame")
local keyTextBox = keySystemFrame:WaitForChild("KeyTextBox")
local checkKeyButton = keySystemFrame:WaitForChild("CheckKeyButton")
local discordButton = keySystemFrame:WaitForChild("DiscordButton")
local statusLabel = keySystemFrame:WaitForChild("StatusLabel") -- You must add a TextLabel named "StatusLabel"
local discordLink = "https://discord.gg/your_invite_code"

local remoteEvent = ReplicatedStorage:WaitForChild("CheckKeyEvent")

-- Function to handle the "Check Key" button click.
checkKeyButton.Activated:Connect(function()
    local enteredKey = keyTextBox.Text
    statusLabel.Text = "Checking key..."
    -- Send the key to the server for verification.
    remoteEvent:FireServer(enteredKey)
end)

-- Function to handle the "Discord" button click.
discordButton.Activated:Connect(function()
    -- This is a simple way to show the link is "copied."
    statusLabel.Text = "Link copied! Join for a key."
    task.wait(2)
    statusLabel.Text = "" -- Clear the status message.
end)

-- This function runs when the server responds to our key check.
remoteEvent.OnClientEvent:Connect(function(isKeyValid)
    if isKeyValid then
        statusLabel.Text = "Key accepted! Unlocking menu..."
        task.wait(1)
        keySystemFrame.Visible = false
        modMenuFrame.Visible = true
    else
        statusLabel.Text = "Invalid key."
        task.wait(2)
        statusLabel.Text = ""
    end
end)
