local ws_url = "ws://127.0.0.1:8080" -- no path
local connect = syn and syn.websocket or WebSocket and WebSocket.connect
assert(connect, "No websocket library found!")

local ws

local function connect_ws()
    ws = connect(ws_url)
end

connect_ws()

while true do
    task.wait(5)
    local ok, err = pcall(function()
        if ws and ws.Send then
            ws:Send('ping')
        else
            connect_ws()
        end
    end)
    if not ok then
        -- Try to reconnect on error
        pcall(function()
            if ws and ws.Close then ws:Close() end
        end)
        connect_ws()
    end
end
