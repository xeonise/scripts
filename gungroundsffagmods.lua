-- gun grounds ffa, gun mods
-- reset after running this script
-- first opensourced gun mod script for game.PlaceId == 12137249458, I'd like to see how other scripts implement it tho.
gunframework = require(game.ReplicatedStorage.ModuleScripts.GunModules.GunFramework)
getgenv().originalnewfunction = gunframework.new
function gunframework.new(arg1)
    -- from the decompilation, the script gets the values from arg1.Configuration, and sets them in a another table, that will be used for gun stats.
    var15 = arg1.Configuration -- that's basically game.Players.Backpack.xweapon.Configuration, could be done with a while true loop(if the executor doesn't have require)
    if var15:FindFirstChild("Recoil") then
        var15:FindFirstChild("Recoil").Value = Vector3.new(0,0,0)
    end
    var15.FireRate.Value = (arg1.Configuration.FireRate.Value) / 10
    var15.reloadTime.Value = 0
    var15.isAuto.Value = true

    return getgenv().originalnewfunction(arg1)
end
