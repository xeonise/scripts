local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Window = Library:CreateWindow({
    Title = 'No Scope Arcade',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

getgenv().statsTables = {}
getgenv().originalValues = {}
for i, v in pairs(getgc(true)) do
    if type(v) == 'table' then
        if rawget(v, 'FireRate') then
            table.insert(getgenv().statsTables, v) 
        end
    end
end 
function backupstat(key)
    for _, tbl in pairs(getgenv().statsTables) do
        if rawget(tbl, key) then
            getgenv().originalValues[key] = tbl[key] 
        end
    end
end
function revertstat(key)
    if getgenv().originalValues[key] then
        for _, tbl in pairs(getgenv().statsTables) do
            if rawget(tbl, key) then
                tbl[key] = getgenv().originalValues[key]
            end
        end
    end
end
function modifystats(key, newValue)
    for _, tbl in pairs(getgenv().statsTables) do
        if rawget(tbl, key) then
            tbl[key] = newValue
        end
    end
end

--getting everything from garbage collector :money_mouth:

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Gun Mods')
LeftGroupBox:AddToggle('rapidfire', {
    Text = 'Rapid Fire',
    Default = true, 
    Tooltip = 'Makes your gun fire rapidly', 

    Callback = function(Value)
        print('[cb] rapidfire changed to:', Value)

        if Value then
            backupstat('FireRate')  -- Backup current FireRate value before changing it
            modifystats("FireRate", 0) -- Set FireRate to 0 for rapid fire
        else
            revertstat('FireRate') -- Revert to the original FireRate value
        end
    end
})
LeftGroupBox:AddToggle('infammo', {
    Text = 'Infinite Ammo',
    Default = true, 
    Tooltip = 'Makes your gun have infinite ammo.', 

    Callback = function(Value)
        print('[cb] infammo changed to:', Value)

        if Value then
            backupstat('ClipSize')
            modifystats("ClipSize", 999999999) 
        else
            revertstat('ClipSize') 
        end
    end
})
LeftGroupBox:AddToggle('automatic', {
    Text = 'Automatic',
    Default = true, 
    Tooltip = 'Makes your gun fire automatically, when you left click.', 

    Callback = function(Value)
        print('[cb] automatic changed to:', Value)

        if Value then
            backupstat('Automatic')
            modifystats("Automatic", true) 
        else
            revertstat('Automatic') 
        end
    end
})
LeftGroupBox:AddToggle('instreload', {
    Text = 'Instant Reload',
    Default = true, 
    Tooltip = 'Makes your gun reload instantly.', 

    Callback = function(Value)
        print('[cb] instreload changed to:', Value)

        if Value then
            backupstat('ReloadTime')
            modifystats("ReloadTime", 0) 
        else
            revertstat('ReloadTime') 
        end
    end
})
LeftGroupBox:AddToggle('norecoil', {
    Text = 'No Recoil',
    Default = true, 
    Tooltip = 'Makes your gun not have recoil, when you shoot.', 

    Callback = function(Value)
        print('[cb] norecoil changed to:', Value)

        if Value then
            backupstat('RecoilMult')
            modifystats("RecoilMult", 0) 
        else
            revertstat('RecoilMult') 
        end
    end
})
local plr = Tabs.Main:AddRightGroupbox('Gun Mods')

plr:AddToggle('BHitboxes', {
    Text = 'Bigger hitboxes',
    Default = true, 
    Tooltip = 'Makes player hitboxes bigger.', 

    Callback = function(Value)
        getgenv().biggerhitbox = Value
        while getgenv().biggerhitbox do task.wait()
        for i,v in next, game:GetService('Players'):GetPlayers() do
            if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(10,10,10)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                    v.Character.HumanoidRootPart.Material = "Neon"
                    v.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end
            end
        end
})




local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

for _, toggle in pairs({ rapidfire = Toggles.rapidfire, infammo = Toggles.infammo, automatic = Toggles.automatic, instreload = Toggles.instreload, norecoil = Toggles.norecoil, BHitboxes = Toggles.BHitboxes }) do
    toggle:SetValue(false)
end -- fix for toggles not working for some reason, when they get autoenabled by the ui library for some reason.





Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Themes')
SaveManager:SetFolder('TDSH/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
