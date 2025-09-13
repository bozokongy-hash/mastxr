-- MASTXR Script Hub (single-file)
-- Rebranded Fluent GUI used as the hub framework
-- Author: Sweb (MASTXR)
-- Discord invite auto-open + copy: https://discord.gg/s2QBMdTF6G

-- ===== Config =====
local DISCORD_INVITE = "https://discord.gg/s2QBMdTF6G"

-- ===== Load Libraries =====
local ok, MASTXR = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)
if not ok or not MASTXR then
    warn("Failed to load MASTXR/Fluent library.")
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ===== Create Window =====
local Window = MASTXR:CreateWindow({
    Title = "MASTXR Script Hub",
    SubTitle = "by Sweb",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ===== Tabs =====
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Brainrot = Window:AddTab({ Title = "Steal a Brainrot", Icon = "cpu" }),
    Rivals = Window:AddTab({ Title = "Rivals", Icon = "swords" }),
    Hypershot = Window:AddTab({ Title = "Hypershot", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- ===== Main Tab =====
Tabs.Main:AddParagraph({
    Title = "Welcome to MASTXR",
    Content = "This is your script hub. Select a tab to load scripts. Invite copied to clipboard on launch."
})

Tabs.Main:AddButton({
    Title = "Test Notification",
    Description = "Shows a test notification",
    Callback = function()
        MASTXR:Notify({
            Title = "MASTXR",
            Content = "Script hub is working!",
            Duration = 5
        })
    end
})

-- ===== Helper: Add Script Button =====
local function AddScriptButton(tab, name, url)
    tab:AddButton({
        Title = name,
        Description = "Load " .. name,
        Callback = function()
            local success, err = pcall(function()
                local source = game:HttpGet(url)
                assert(source and #source > 0, "Empty response or bad URL")
                loadstring(source)()
            end)
            if not success then
                MASTXR:Notify({
                    Title = "MASTXR",
                    Content = "Failed to load script: " .. name,
                    SubContent = tostring(err),
                    Duration = 6
                })
                warn("MASTXR: failed to load script:", name, err)
            else
                MASTXR:Notify({
                    Title = "MASTXR",
                    Content = "Loaded: " .. name,
                    Duration = 4
                })
            end
        end
    })
end

-- ===== Brainrot Tab (replace URLs with actual script raw URLs) =====
AddScriptButton(Tabs.Brainrot, "Brainrot - Script A", "https://raw.githubusercontent.com/YourRepo/BrainrotA/main/brainrotA.lua")
AddScriptButton(Tabs.Brainrot, "Brainrot - Script B", "https://raw.githubusercontent.com/YourRepo/BrainrotB/main/brainrotB.lua")

-- ===== Rivals Tab (replace URLs with actual script raw URLs) =====
AddScriptButton(Tabs.Rivals, "Rivals - Script A", "https://raw.githubusercontent.com/YourRepo/RivalsA/main/rivalsA.lua")
AddScriptButton(Tabs.Rivals, "Rivals - Script B", "https://raw.githubusercontent.com/YourRepo/RivalsB/main/rivalsB.lua")

-- ===== Hypershot Tab (replace URLs with actual script raw URLs) =====
AddScriptButton(Tabs.Hypershot, "Hypershot - Script A", "https://raw.githubusercontent.com/YourRepo/HypershotA/main/hypershotA.lua")
AddScriptButton(Tabs.Hypershot, "Hypershot - Script B", "https://raw.githubusercontent.com/YourRepo/HypershotB/main/hypershotB.lua")

-- ===== Settings Tab: Discord & Config Controls =====
Tabs.Settings:AddParagraph({
    Title = "MASTXR Settings",
    Content = "Save/load GUI configs below and use the button to open/join Discord."
})

Tabs.Settings:AddButton({
    Title = "Open / Copy Discord Invite",
    Description = DISCORD_INVITE,
    Callback = function()
        -- copy to clipboard
        pcall(function()
            if setclipboard then
                setclipboard(DISCORD_INVITE)
            end
        end)
        -- try to open the invite via a simple GET request if available (some executors allow this)
        pcall(function()
            if syn and syn.request then
                syn.request({ Url = DISCORD_INVITE, Method = "GET" })
            elseif request then
                request({ Url = DISCORD_INVITE, Method = "GET" })
            end
        end)
        -- notify user
        MASTXR:Notify({
            Title = "MASTXR",
            Content = "Discord invite copied to clipboard.",
            SubContent = DISCORD_INVITE,
            Duration = 6
        })
    end
})

-- ===== SaveManager & InterfaceManager Setup =====
SaveManager:SetLibrary(MASTXR)
InterfaceManager:SetLibrary(MASTXR)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("MASTXRHub/configs")
InterfaceManager:SetFolder("MASTXRHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ===== Select first tab by default =====
Window:SelectTab(1)

-- ===== Auto-copy & auto-open Discord Invite on hub load =====
task.spawn(function()
    -- copy invite to clipboard (best-effort)
    pcall(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
        end
    end)

    -- optional GET to the invite (some executors allow a browser/open behavior)
    pcall(function()
        if syn and syn.request then
            syn.request({ Url = DISCORD_INVITE, Method = "GET" })
        elseif request then
            request({ Url = DISCORD_INVITE, Method = "GET" })
        end
    end)

    -- in-hub notification
    MASTXR:Notify({
        Title = "MASTXR",
        Content = "Discord invite copied to clipboard.",
        SubContent = DISCORD_INVITE,
        Duration = 8
    })

    -- also show a dialog with open/cancel that users can click (dialog doesn't open external links by itself)
    Window:Dialog({
        Title = "Join our Discord?",
        Content = "Invite has been copied to your clipboard:\n\n" .. DISCORD_INVITE .. "\n\nClick Open to attempt to open it (may require a compatible executor).",
        Buttons = {
            {
                Title = "Open",
                Callback = function()
                    -- second attempt to open via request
                    pcall(function()
                        if syn and syn.request then
                            syn.request({ Url = DISCORD_INVITE, Method = "GET" })
                        elseif request then
                            request({ Url = DISCORD_INVITE, Method = "GET" })
                        end
                    end)
                    MASTXR:Notify({ Title = "MASTXR", Content = "Tried to open the invite.", Duration = 4 })
                end
            },
            {
                Title = "Close",
                Callback = function()
                    -- no-op
                end
            }
        }
    })
end)

-- ===== Final loaded notification =====
MASTXR:Notify({
    Title = "MASTXR",
    Content = "Script hub loaded successfully.",
    SubContent = "Discord invite copied to clipboard.",
    Duration = 6
})

-- ===== End of file =====
