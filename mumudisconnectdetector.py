import cv2
import numpy as np
import pyautogui
import win32gui
import subprocess
import time
import os

# Configuration
MUMU_ADB_PATH = r"C:\Program Files\Netease\MuMuPlayerGlobal-12.0\shell\adb.exe"
ADB_SERVER = "127.0.0.1:7555"
WINDOW_TITLE = "MuMu Player 12-1"
TEMPLATE_IMAGE_PATH = "image.png"
CONFIDENCE_THRESHOLD = 0.9
ROBLOX_PACKAGE = "com.roblox.client"
PLACE_ID = "9503261072"
CHECK_INTERVAL = 0  # seconds between checks

def get_window_screenshot(window_title):
    try:
        hwnd = win32gui.FindWindow(None, window_title)
        if hwnd == 0:
            raise Exception(f"Window '{window_title}' not found")
        
        left, top, right, bottom = win32gui.GetWindowRect(hwnd)
        width = right - left
        height = bottom - top
        
        screenshot = pyautogui.screenshot(region=(left, top, width, height))
        return cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
    except Exception as e:
        print(f"Error capturing window screenshot: {e}")
        return None

def find_image_in_screenshot(screenshot, template_path, threshold=0.8):
    try:
        template = cv2.imread(template_path, cv2.IMREAD_COLOR)
        if template is None:
            raise Exception(f"Could not load template image from {template_path}")
        
        res = cv2.matchTemplate(screenshot, template, cv2.TM_CCOEFF_NORMED)
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)
        
        if max_val >= threshold:
            print(f"Image found with confidence: {max_val:.2f}")
            return True, max_loc
        else:
            print(f"Image not found (best match confidence: {max_val:.2f})")
            return False, None
    except Exception as e:
        print(f"Error in image matching: {e}")
        return False, None

def execute_adb_command(command):
    try:
        # Connect to ADB server first
        connect_cmd = [MUMU_ADB_PATH, "connect", ADB_SERVER]
        subprocess.run(connect_cmd, check=True, capture_output=True, text=True)
        
        # Execute the actual command
        full_cmd = [MUMU_ADB_PATH, "-s", ADB_SERVER] + command.split()
        result = subprocess.run(full_cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"ADB command failed: {result.stderr}")
            return False
        else:
            print(f"ADB command successful: {result.stdout}")
            return True
    except subprocess.CalledProcessError as e:
        print(f"ADB connection failed: {e.stderr}")
        return False
    except Exception as e:
        print(f"Error executing ADB command: {e}")
        return False

def restart_roblox():
    print("Restarting Roblox...")
    
    # Kill Roblox
    if not execute_adb_command(f"shell am force-stop {ROBLOX_PACKAGE}"):
        print("Failed to kill Roblox")
        return False
    
    time.sleep(2)  # Wait for process to terminate
    
    # Launch specific Roblox place using deep link
    launch_command = f'shell su -c \'am start -a android.intent.action.VIEW -d "roblox://placeID={PLACE_ID}"\''
    
    if not execute_adb_command(launch_command):
        print("Failed to launch Roblox")
        return False
    
    return True

if __name__ == "__main__":
    # Verify ADB executable exists
    if not os.path.exists(MUMU_ADB_PATH):
        print(f"ADB executable not found at: {MUMU_ADB_PATH}")
        exit(1)
    
    print(f"Starting continuous search for template image (checking every {CHECK_INTERVAL} seconds)")
    print("Press Ctrl+C to stop the script")
    
    try:
        while True:
            screenshot = get_window_screenshot(WINDOW_TITLE)
            if screenshot is None:
                time.sleep(CHECK_INTERVAL)
                continue
            
            found, location = find_image_in_screenshot(screenshot, TEMPLATE_IMAGE_PATH, CONFIDENCE_THRESHOLD)
            
            if found:
                print("Template image found - restarting Roblox to specific place")
                if restart_roblox():
                    print("Roblox restart completed successfully")
                    # Wait longer after restart to avoid immediate re-trigger
                    time.sleep(30)
                else:
                    print("Failed to restart Roblox")
            
            time.sleep(CHECK_INTERVAL)
    except KeyboardInterrupt:
        print("\nScript stopped by user")
