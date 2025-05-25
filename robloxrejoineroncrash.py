import time
import requests
import urllib.parse
import webbrowser
import psutil

COOKIE = "_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_......"
PLACE_ID = "9503261072"
def get_ticket(cookie):
    s = requests.Session()
    s.cookies['.ROBLOSECURITY'] = cookie
    r = s.post("https://auth.roblox.com/v2/logout")
    csrf = r.headers.get("x-csrf-token", "")
    if not csrf:
        print("Failed to get CSRF token")
        return None
    r = s.post(
        "https://auth.roblox.com/v1/authentication-ticket",
        headers={
            "X-CSRF-TOKEN": csrf,
            "Referer": "https://www.roblox.com/",
            "Content-Type": "application/json"
        }
    )
    return r.headers.get("rbx-authentication-ticket", "")
def launch_roblox(ticket):
    place_url = f"https://www.roblox.com/games/start?placeId={PLACE_ID}"
    protocol_url = (
        f"roblox-player://1+launchmode:play+"
        f"gameinfo:{ticket}+"
        f"launchtime:{int(time.time() * 1000)}+"
        f"placelauncherurl:{urllib.parse.quote(place_url)}"
    )
    webbrowser.open(protocol_url)

def is_roblox_running():
    return any(
        p.info['name'] and 'RobloxPlayerBeta.exe' in p.info['name']
        for p in psutil.process_iter(['name'])
    )
if __name__ == "__main__":
    while True:
        if not is_roblox_running():
            ticket = get_ticket(COOKIE)  # Re-fetch ticket each time
            if not ticket:
                print("Failed to get authentication ticket")
                time.sleep(5)
                continue
            launch_roblox(ticket)
            for _ in range(15):
                if is_roblox_running():
                    break
                time.sleep(1)
            else:
                ticket = get_ticket(COOKIE)  # Re-fetch ticket if launch fails
                if ticket:
                    launch_roblox(ticket)
        while is_roblox_running():
            time.sleep(2)
