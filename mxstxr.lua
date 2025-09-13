-- MASTXR GUI Hub
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Fluent"):WaitForChild("MainModule"))

-- Create the main window
local Window = Library:Window{
    Title = `MASTXR {Library.Version}`,
    SubTitle = "by Sweb & Team",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    Acrylic = true,
    Theme = "Vynixu",
    MinimizeKey = Enum.KeyCode.P
}

-- Create tabs
local Tabs = {
    Main = Window:Tab{Title = "Main", Icon = "phosphor-users-bold"},
    Settings = Window:Tab{Title = "Settings", Icon = "settings"}
}

-- ===== Main Tab Components =====

-- Paragraph examples
local Paragraph = Tabs.Main:Paragraph("Paragraph", {
    Title = "Paragraph",
    Content = "This is a paragraph.\nSecond line!"
})
Paragraph:SetValue("This paragraph text is changed!")

Tabs.Main:Paragraph("AlignedParagraph", {
    Title = "Paragraph",
    Content = "This is a paragraph with a center alignment!",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

-- Buttons
Tabs.Main:Button({
    Title = "Show Dialog",
    Description = "Click to open a dialog",
    Callback = function()
        local D = Window:Dialog({
            Title = "Dialog Title",
            Content = "This is a sample dialog.",
            Buttons = {
                {Title = "Confirm", Callback = function()
                    Window:Dialog({
                        Title = "Another Dialog",
                        Content = "Example nested dialog content.",
                        Buttons = {{Title = "Ok", Callback = function() print("Ok pressed") end}}
                    })
                end},
                {Title = "Cancel", Callback = function() print("Dialog cancelled") end}
            }
        })
        D.Closed:Wait()
        print("Dialog closed")
    end
})

Tabs.Main:Button({
    Title = "Error Button Example",
    Description = "This prints an error intentionally",
    Callback = function()
        print("Hello, "..tostring("World").."!")
    end
})

-- Toggles
local Toggle = Tabs.Main:Toggle("DemoToggle", {Title = "Toggle", Default = false})
Toggle:OnChanged(function()
    print("Toggle changed:", Library.Options["DemoToggle"].Value)
end)

-- Sliders
local Slider = Tabs.Main:Slider("DemoSlider", {
    Title = "Slider",
    Description = "Demo slider",
    Default = 2.0,
    Min = 0.0,
    Max = 15.5,
    Rounding = 1
})
Slider.Value = 4.5
Slider:OnChanged(function(Value)
    print("Slider changed:", Value)
end)

-- Dropdowns
local Dropdown = Tabs.Main:Dropdown("DemoDropdown", {
    Title = "Dropdown",
    Values = {"one","two","three","four","five","six","seven","eight","nine","ten"},
    Multi = false,
    Default = 1
})
Dropdown:SetValue("four")
Dropdown:OnChanged(function(Value)
    print("Dropdown changed:", Value)
end)

local MultiDropdown = Tabs.Main:Dropdown("DemoMultiDropdown", {
    Title = "MultiDropdown",
    Description = "Select multiple values",
    Values = {"one","two","three","four","five"},
    Multi = true,
    Default = {"two","five"}
})
MultiDropdown:SetValue({one=true, three=true})
MultiDropdown:OnChanged(function(Value)
    local Values = {}
    for K, V in next, Value do table.insert(Values, K) end
    print("MultiDropdown changed:", table.concat(Values, ", "))
end)

-- Colorpickers
local Colorpicker = Tabs.Main:Colorpicker("DemoColorpicker", {Title = "Colorpicker", Default = Color3.fromRGB(96,205,255)})
Colorpicker:OnChanged(function()
    print("Colorpicker changed:", Colorpicker.Value)
end)

local TColorpicker = Tabs.Main:Colorpicker("DemoTransColorpicker", {Title="TransparencyColorpicker", Transparency=0, Default=Color3.fromRGB(96,205,255)})
TColorpicker:OnChanged(function()
    print("TColorpicker changed:", TColorpicker.Value, "Transparency:", TColorpicker.Transparency)
end)

local CColorpicker = Tabs.Main:Colorpicker("DemoUpdateColorpicker", {Title="Realtime Colorpicker", Transparency=0, Default=Color3.fromRGB(96,205,255), UpdateOnChange=true})
CColorpicker:OnChanged(function()
    print("Realtime Colorpicker changed:", CColorpicker.Value, "Transparency:", CColorpicker.Transparency)
end)

-- Keybind
local Keybind = Tabs.Main:Keybind("DemoKeybind", {Title="KeyBind", Mode="Hold", Default="LeftControl", ChangedCallback=function(New) print("Keybind changed:", New) end})
task.spawn(function()
    while true do
        wait(1)
        if Keybind:GetState() then
            print("Keybind is being held down")
        end
        if Library.Unloaded then break end
    end
end)

-- Input boxes
local Input = Tabs.Main:Input("DemoInput", {Title="Input", Default="Default", Numeric=false, Finished=false, Placeholder="Placeholder", Callback=function(Value) print("Input changed:", Value) end})
local InputLostFocus = Tabs.Main:Input("DemoInputFocus", {Title="InputFocusLost", Default="Default", ClearOnFocusLost=true, Numeric=false, Finished=true, Placeholder="Placeholder", Callback=function(Value) print("Input changed:", Value) end})

-- ===== Settings Tab =====
local InterfaceSection = Tabs.Settings:Section("Interface")

-- Theme Dropdown
InterfaceSection:Dropdown("InterfaceTheme", {Title="Theme", Description="Change theme", Values=Library.Themes, Default=Library.Theme, Callback=function(Value) Library:SetTheme(Value) end})

-- Acrylic toggle
if Library.UseAcrylic then
    InterfaceSection:Toggle("AcrylicToggle", {Title="Acrylic", Description="Blurred background requires graphic quality 8+", Default=Library.Acrylic, Callback=function(Value) Library:ToggleAcrylic(Value) end})
end

-- Transparency toggle
InterfaceSection:Toggle("TransparentToggle", {Title="Transparency", Description="Makes the interface transparent.", Default=Library.Transparency, Callback=function(Value) Library:ToggleTransparency(Value) end})

-- Minimize keybind
InterfaceSection:Keybind("MenuKeybind", {Title="Minimize Bind", Default=Library.MinimizeKey or Enum.KeyCode.RightShift, ChangedCallback=function(Value) Library.MinimizeKey = Value end})
Library.MinimizeKeybind = Library.Options.MenuKeybind

-- Select first tab by default
Window:SelectTab(1)

-- Notification on load
Library:Notify({
    Title = "MASTXR",
    Content = "The MASTXR script hub has been loaded successfully.",
    Duration = 8,
    Sound = {SoundId = "rbxassetid://8486683243"}
})
