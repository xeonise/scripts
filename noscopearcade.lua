repeat
    task.wait()
until game:IsLoaded()
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

gh = loadstring(game:HttpGet("https://raw.githubusercontent.com/xeonise/scripts/refs/heads/main/gc.lua",true))()


--getting everything from garbage collector :money_mouth:

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}
gh.findgc({"FireRate","ReloadTime","RecoilMult"}, {"Main","Gun","SettingMod","WallJump","Running","Slide"})

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Gun Mods')
LeftGroupBox:AddToggle('rapidfire', {
    Text = 'Rapid Fire',
    Default = true, 
    Tooltip = 'Makes your gun fire rapidly', 

    Callback = function(Value)
        print('[cb] rapidfire changed to:', Value)

        if Value then
            gh.backupstat(1,"FireRate")
            gh.modifystats(1,"FireRate",0) -- Set FireRate to 0 for rapid fire
        else
            gh.revertstat(1,"FireRate") -- Revert to the original FireRate value
        end
    end
})
LeftGroupBox:AddToggle('infammo', {
    Text = 'Infinite Ammo',
    Default = true, 
    Tooltip = 'Makes your gun have infinite ammo.', 

    Callback = function(Value)
        print('[cb] infammo changed to:', Value)

        while Value do task.wait()
        if Value then
            gh.backupstat(1,"ClipSize")
            gh.modifystats(1,"ClipSize",999999999) 
        else
            gh.revertstat(1,"ClipSize") 
        end
    end
    end
})
LeftGroupBox:AddToggle('automatic', {
    Text = 'Automatic',
    Default = true, 
    Tooltip = 'Makes your gun fire automatically, when you left click.', 

    Callback = function(Value)
        print('[cb] automatic changed to:', Value)
        while Value do task.wait()

        if Value then
            gh.backupstat(1,"Automatic")
            gh.modifystats(1,"Automatic",true,"boolean") 
        else
            gh.revertstat(1,"Automatic") 
        end
    end
    end
})
LeftGroupBox:AddToggle('instreload', {
    Text = 'Instant Reload',
    Default = true, 
    Tooltip = 'Makes your gun reload instantly.', 

    Callback = function(Value)
        print('[cb] instreload changed to:', Value)
        while Value do task.wait()

        if Value then
            gh.backupstat(1,"ReloadTime")
            gh.modifystats(1,"ReloadTime",0) 
        else
            gh.revertstat(1,"ReloadTime") 
        end
    end
    end
})
LeftGroupBox:AddToggle('norecoil', {
    Text = 'No Recoil',
    Default = true, 
    Tooltip = 'Makes your gun not have recoil, when you shoot.', 

    Callback = function(Value)
        print('[cb] norecoil changed to:', Value)
        while Value do task.wait()

        if Value then
            gh.backupstat(1,"RecoilMult")
            gh.modifystats(1,"RecoilMult",0) 
        else
            gh.revertstat(1,"RecoilMult") 
        end
    end
    end
})
local plr = Tabs.Main:AddRightGroupbox('Player')

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

plr:AddSlider('FOV', {
    Text = 'Field Of View',
    Default = 2,
    Min = 0,
    Max = 8, -- ingame fov is a little bit different in values for some reason
    Rounding = 0,
    Compact = false,
    Callback = function(fov)
        gh.modifystats(2,"Main", fov)
        gh.modifystats(2,"Gun", fov)
        gh.modifystats(2,"SettingMod", fov)
        gh.modifystats(2,"WallJump", fov)
        gh.modifystats(2,"Running", fov)
        gh.modifystats(2,"Slide", fov)
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
