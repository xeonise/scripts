getgenv().playerNames = {"p1", "p2"}
local lobbyPlaceId = 3260590327
local server = 'http://localhost:8080'
getgenv().p1straturl = ''
getgenv().p2straturl = ''
getgenv().p3straturl = ''
getgenv().p4straturl = ''

function joingame()
    game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Multiplayer", "single_create")
    local ohTable3 = {
        ["count"] = tonumber(#getgenv().playerNames),
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
            task.wait(1)
            response = request({
                Url = server .. "/getserver",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["JobId"] = game.JobId,
                    ["PlaceId"] = tostring(game.PlaceId) -- Ensure PlaceId is a string
                }
            })
        
        until response.StatusCode ~= 400 and not response:find("Error")  -- Repeat until the status code is not 400 and no error in the response
        lobbytper()
    else
        repeat
            task.wait(1)
            response = request({
                Url = server .. "/getserver",
                Method = "GET",
                Headers = {
                    ["Content-Type"] = "application/json"
                }
            }).Body
        until response.StatusCode ~= 400 and not response:find("Error")  -- Repeat until the status code is not 400 and there's no "Error" in the response
        local jobId, placeId = response:match("JobId: (%S+), PlaceId: (%S+)")
        if jobId and placeId then
            if jobId ~= game.JobId then
                local success, message
                repeat
                    success, message = pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId, game.Players.LocalPlayer)
                    end)
                    if not success and string.match(message, "Server is full") then
                        print("Server is full, retrying...")
                        task.wait(1)  -- Wait 5 seconds before retrying
                    end
                until success
                print("Successfully teleported!")
            else
                lobbytper()
            end
        else
            print("Error: Invalid response or missing JobId/PlaceId")
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
elseif game.PlaceId == 5591597781 then 
    if playerName == getgenv().playerNames[1] and getgenv().straturl1 then
        loadstring(game:HttpGet(tostring(getgenv().straturl1),true))()
    elseif playerName == getgenv().playerNames[2] and getgenv().straturl2 and #getgenv().playerNames == 2 then
        loadstring(game:HttpGet(tostring(getgenv().stratur2l),true))()
    elseif playerName == getgenv().playerNames[3] and getgenv().straturl3 and #getgenv().playerNames == 3 then
        loadstring(game:HttpGet(tostring(getgenv().straturl3),true))()
    elseif playerName == getgenv().playerNames[4] and getgenv().straturl4 and #getgenv().playerNames == 4 then
        loadstring(game:HttpGet(tostring(getgenv().straturl4),true))()
    end
 
end
