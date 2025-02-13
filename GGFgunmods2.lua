-- variant 2 for shit sploits like solara/xeno, etc. ; also require exists in xeno, but when I tried to change a function with it, it gave me a error, due to the level of the executor being low.
while true do task.wait()
    local player = game.Players.LocalPlayer
    local item = workspace:FindFirstChild(player.Name):FindFirstChildOfClass("Tool")
    if item then
        local config = item:FindFirstChild("Configuration")
        if config then
            if config:FindFirstChild("reloadTime") then 
                config.reloadTime.Value = 0
            end
            if config:FindFirstChild("FireRate") then 
                config.FireRate.Value = 0
            end
            if config:FindFirstChild("recoil") then
                config.recoil.Value = 0
            end
            if config:FindFirstChild("isAuto") then
                config.isAuto.Value = true
            end 
        end
    end
end
