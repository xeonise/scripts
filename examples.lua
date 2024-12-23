-- getgc example to find tables with gun values
for i, v in pairs(getgc(true)) do
        if type(v) == 'table' then
            if rawget(v, 'Ammo') then
                v["Ammo"] = 9999999999999999
                v["ReloadTime"] = 0
                v["AttackRate"] = 5000
                v["BulletDamage"] = 5000
                v["Automatic"] = true
            end
        end
    end

-- hookmetamethod example
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" and tostring(self) == "CheckShot" then
        args[6] = direction to closest player
    end

    return oldNamecall(self, ...)
end)

-- hooking functions in the getgc example, by function name, and by function upvalues
-- credits to https://github.com/Coolmandfgfgdvcgfg/Wave-Inject-Crash-fix
for Index, Data in next, getgc() do
    pcall(function()
        local info = debug.getinfo(Data)
        local up = debug.getconstants(Data)
        if typeof(Data) == "function" and info.name == "Immutable" then
            hookfunction(Data, function()
                return nil
            end)
        elseif typeof(Data) == "function" and table.find(up, "MethodError") and table.find(up, "ServerError") and table.find(up, "ReadError") then
            hookfunction(Data, function()
                return nil
            end)
        end
    end)
end



