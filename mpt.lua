-- Variables and functions are the same
getgenv().playerNames = {"tdsaltkn", "Vikilerm"}
local lobbyPlaceId = 3260590327
local server = 'http://localhost:8080'

function joingame()
    -- Call the matchmaking remote for whatever you're playing here
    game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Multiplayer", "single_create")
    local ohTable3 = {
        ["count"] = tonubmer(#getgenv().playerNames),
        ["mode"] = "badlands",
        ["challenge"] = "Badlands"
    }
    game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Multiplayer", "v2:start", ohTable3)
end

function ready()
    local playerName = game.Players.LocalPlayer.Name
    if playerName == getgenv().playerNames[1] then
        local args = {
            [1] = "Party",
            [2] = "CreateParty"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))

        for _, name in pairs(getgenv().playerNames) do
            if name ~= playerName then
                local args = {
                    [1] = "Party",
                    [2] = "InvitePlayer",
                    [3] = game.Players[name] -- invite this player
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
            end
        end
        task.wait(2)
        joingame()
    else
        task.wait(1)
        game.ReplicatedStorage.RemoteFunction:InvokeServer("Party", "AcceptInvite", game.Players[getgenv().playerNames[1]])
    end
end

function lobbytper()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(70, 112, 89))
end

if game.PlaceId == lobbyPlaceId then
    print("Lobby")

    if game.Players.LocalPlayer.Name == getgenv().playerNames[1] then
        repeat
        response = request({
            Url = server .. "/getserver",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["JobId"] = game.JobId,
                ["PlaceId"] = tostring(game.PlaceId) -- Ensure PlaceId is a string
            }
        })
        until response.StatusCode ~= 400 -- Repeat until the status code is not 400

        lobbytper()
    else
        repeat
        local response = request({
            Url = server .. "/getserver",
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        }).Body
        until response.StatusCode ~= 400 -- Repeat until the status code is not 400
        local data = game:GetService("HttpService"):JSONDecode(response)
        if data.JobId ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.JobId, game.Players.LocalPlayer)
        else
            lobbytper()
        end

    end  

    while true do task.wait()
        local allReady = true
        for _, playerName in pairs(getgenv().playerNames) do
            local player = game.Players:FindFirstChild(playerName)

            if not player or not player.Character or not player.Character.PrimaryPart or
                (player.Character.PrimaryPart.Position - Vector3.new(70, 112, 89)).magnitude > 10 then
                allReady = false
                break
            end
        end
        if allReady then
            ready()
            break 
        end

        task.wait(0.5) 
    end
end
