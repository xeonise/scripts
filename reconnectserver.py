import websockets
import asyncio
import os
import time
from threading import Thread
from datetime import datetime

HOST = "127.0.0.1"
PORT = 8080
TIMEOUT = 120  # 2 minutes in seconds

last_message_time = time.time()

def debug_log(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {message}")

async def handle_connection(websocket):
    global last_message_time
    client_ip = websocket.remote_address[0]
    debug_log(f"New connection from {client_ip}")

    try:
        async for message in websocket:
            last_message_time = time.time()
            debug_log(f"Received message from {client_ip}: {message}")
            await websocket.send("OK")
            debug_log(f"Sent response to {client_ip}")
    except websockets.exceptions.ConnectionClosed:
        debug_log(f"Connection with {client_ip} closed")
    except Exception as e:
        debug_log(f"Error with {client_ip}: {str(e)}")

def check_timeout():
    global last_message_time
    while True:
        current_time = time.time()
        elapsed = current_time - last_message_time
        debug_log(f"Checking timeout - Last ping: {elapsed:.1f}s ago")

        if elapsed > TIMEOUT:
            debug_log("❗ Timeout reached! Launching Roblox...")
            os.system('su -c \'am start -a android.intent.action.VIEW -d "roblox://placeID=9503261072"\'')
            last_message_time = current_time  # Reset timer
        time.sleep(5)

async def start_server():
    server = await websockets.serve(handle_connection, HOST, PORT)
    debug_log(f"WebSocket server started on ws://{HOST}:{PORT}")
    await server.wait_closed()

if __name__ == "__main__":
    debug_log("Starting server...")
    # Start timeout checker in background
    Thread(target=check_timeout, daemon=True).start()

    # Start WebSocket server
    asyncio.get_event_loop().run_until_complete(start_server())
    asyncio.get_event_loop().run_forever()
