--govno tb autofarm
getgenv().p1 = "p1" -- the one who wins
getgenv().p2 = "p2"      -- the one who gives the win

local function LaunchPrivateServer()
    local info = {
        placeId = 45146873,
        linkCode = '98482503492618179290768057799030'
    }
    game:GetService('ExperienceService'):LaunchExperience(info)
    task.wait(2.5)
    game:Shutdown() -- delta only launches the exp after shutdown for some reason
end

if game.PlaceId == 45146873 then -- Lobby
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer

    if #Players:GetPlayers() > 2 then
        warn("Too many players in server, teleporting to private server...")
        LaunchPrivateServer()
        return
    end

    local function enter1v1Room()
        workspace:WaitForChild("Enter"):InvokeServer("1v1", 2)
    end

    local function begin1v1Game()
        workspace:WaitForChild("BeginGame"):InvokeServer("1v1", 2)
    end

    if plr.Name == getgenv().p1 then
        -- p1 joins first
        enter1v1Room()
    elseif plr.Name == getgenv().p2 then
        -- p2 waits for p1 for up to 3 minutes
        local startTime = tick()
        local room = workspace:WaitForChild("Rooms"):WaitForChild("1v1"):WaitForChild("1")

        while room.Value == "Empty" or room.Value ~= getgenv().p1 do
            if tick() - startTime > 180 then -- 3 minutes timeout
                warn("Timeout waiting for p1 to join.")
                LaunchPrivateServer()
                return
            end
            task.wait(1)
        end

        -- p1 is in, now p2 enters and starts the game
        enter1v1Room()
        task.wait(1)
        begin1v1Game()
    end
end


if game.PlaceId == 46955756 then -- the game part
    local plr = game.Players.LocalPlayer
    local gui = plr.PlayerGui:WaitForChild("Stats"):WaitForChild("Ticker")

    -- Wait until "Game begins in" phase starts
    repeat task.wait() until string.find(gui.Wave.Text, "Game begins in")

    -- Access map GUI
    local booth = plr.PlayerGui.Stats.Vote.Vote.Booth

    local function parseLength(text)
        local number = string.match(text, "%d+")
        return tonumber(number) or math.huge
    end

    -- Collect map data
    local maps = {
        {
            id = "Map1",
            len = parseLength(booth.Map1.Difficulty.Text),
            name = (booth.Map1:FindFirstChild("mapName") and booth.Map1.mapName.Text) or booth.Map1.Name or "Unknown"
        },
        {
            id = "Map2",
            len = parseLength(booth.Map2.Difficulty.Text),
            name = (booth.Map2:FindFirstChild("mapName") and booth.Map2.mapName.Text) or booth.Map2.Name or "Unknown"
        },
        {
            id = "Map3",
            len = parseLength(booth.Map3.Difficulty.Text),
            name = (booth.Map3:FindFirstChild("mapName") and booth.Map3.mapName.Text) or booth.Map3.Name or "Unknown"
        },
    }

    -- Debug prints
    for _, m in ipairs(maps) do
        print(("[DEBUG] %s - %s -- Parsed Length: %s"):format(m.id, m.name, m.len))
    end

    -- Sort by length (ascending)
    table.sort(maps, function(a, b)
        return a.len < b.len
    end)

    -- Choose shortest map, but avoid "Castle"
    local chosen = maps[1]
    if chosen.name == "Castle" then
        chosen = maps[2] or chosen -- fallback if only Castle is available
        warn("[INFO] Shortest map was Castle, selecting second shortest:", chosen.name)
    end

    local shortestMap = chosen.id

    -- Vote for the selected map
    workspace:WaitForChild("Vote"):InvokeServer(shortestMap)
    workspace:WaitForChild("SkipWaitVote"):InvokeServer()

    -- Wait until Wave 1 starts
    repeat task.wait() until gui.Wave.Text == "Wave 1"

    -- Place Patrol using vector.create
    local yPos = plr.Name == getgenv().p1 and -372 or -430
    local args = {
        vector.create(0, yPos, 0),
        1,
        "Patrol",
        workspace:WaitForChild("Map"):WaitForChild("Grass")
    }
    workspace:WaitForChild("Placed"):InvokeServer(unpack(args))

    -- Get matching patrol tower
    local function GetPatrolTowerId()
        for _, t in pairs(workspace.Towers:GetChildren()) do
            if t:FindFirstChild("Owner") and t.Owner.Value == plr then
                local towerType = t:FindFirstChild("Tower") and t.Tower:FindFirstChild("Tower")
                if towerType and towerType.Value == "Patrol" then
                    getgenv().matchtower = t
                    return t.Name
                end
            end
        end
    end

    local id = GetPatrolTowerId()

    -- Upgrade to level 3
    task.spawn(function()
        local upgrade = workspace:WaitForChild("UpgradeTower")
        while workspace.Towers:FindFirstChild(id) and workspace.Towers[id].Tower.UP1.Value < 3 do
            upgrade:InvokeServer(id)
            task.wait()
        end
    end)

    -- p2 sells at Wave 7
    task.spawn(function()
        if plr.Name == getgenv().p2 then
            repeat task.wait() until gui.Wave.Text == "Wave 7"
            workspace:WaitForChild("SellTower"):InvokeServer(id)
        end
    end)

    -- p1 starts Speedy spam at Wave 7
    task.spawn(function()
        if plr.Name == getgenv().p1 then
            repeat task.wait() until gui.Wave.Text == "Wave 7"
            task.wait(5)
            while true do
                workspace:WaitForChild("BuyZombie"):InvokeServer("Speedy")
                workspace:WaitForChild("Make"):InvokeServer("Speedy")
                task.wait(1)
            end
        end
    end)

    -- Restart run on win
    task.spawn(function()
        while true do
            if string.find(gui.Wave.Text:lower(), "won") then
                if typeof(LaunchPrivateServer) == "function" then
                    LaunchPrivateServer()
                else
                    warn("LaunchPrivateServer() is not defined yet.")
                end
                break
            end
            task.wait(1)
        end
    end)
end
