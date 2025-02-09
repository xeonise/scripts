-- variant 2 for shit sploits like solara/xeno, etc. ; also require exists in xeno, but when I tried to change a function with it, it gave me a error, due to the level of the executor being low.
while true do task.wait()
    local item = workspace:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChildOfClass("Tool")
    if item then
        if item.Configuration.reloadTime then 
            item.Configuration.reloadTime.Value = 0
        elseif item.Configuration.FireRate then 
            item.Configuration.FireRate.Value = 0
        elseif item.Configuration.recoil then
            item.Configuration.recoil.Value = 0
        elseif item.Configuration.isAuto then
            item.Configuration.isAuto.Value = true
        end 
    end
end
