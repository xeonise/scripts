from http.server import BaseHTTPRequestHandler, HTTPServer
import threading
import time
import os

HOST = "127.0.0.1"
PORT = 8080
TIMEOUT = 120  # 2 минуты (в секундах)

last_message_time = time.time()

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        global last_message_time
        if self.path == "/stillrunning":
            last_message_time = time.time()
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
        else:
            self.send_response(404)
            self.end_headers()

def check_timeout():
    global last_message_time
    while True:
        if time.time() - last_message_time > TIMEOUT:
            print("❗ Таймаут! Запускаем Roblox...")
            os.system('su -c \'am start -a android.intent.action.VIEW -d "roblox://placeID=9503261072"\'')
            last_message_time = time.time()  # Сброс таймера
        time.sleep(5)

if __name__ == "__main__":
    # Запускаем проверку таймаута в фоне
    threading.Thread(target=check_timeout, daemon=True).start()
    
    # Запускаем HTTP-сервер
    server = HTTPServer((HOST, PORT), Handler)
    print(f"Сервер запущен на http://{HOST}:{PORT}")
    server.serve_forever()
