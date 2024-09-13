#!/usr/bin/env python3
# Run privileged: `sudo /usr/bin/python3 rtsp-feed.py`
import os
import sys
import subprocess

# Ask wsdd nicely to terminate.
interface = os.environ.get('INTERFACE')
if interface is None:
    print("No interface such as 'eth0' or 'eno1' provided")
    sys.exit(1)

directory = os.environ.get('DIRECTORY')
if directory is None:
    directory = "/onvif-camera-server"
    print("No scripts directory provided. Using the directory the script was executed from: {}".format(directory))
else:
    print("Using provided directory. The script was executed from:: {}".format(directory))

firmware_ver = os.environ.get('FIRMWARE')
if firmware_ver is None:  
    print("No firmware version provided. Using default 1.0")
    firmware_ver = "1.0" 
else:
    print("Using provided firmware version: {}".format(firmware_ver))
    
if os.system("pgrep wsdd > /dev/null") == 0:
    print("Killing previous wssd instances")
    os.system("sudo pkill wsdd")

# Forcibly terminate.
if os.system("pgrep wsdd > /dev/null") == 0:
    os.system("sudo pkill -9 wsdd")

# Ask onvif server nicely to terminate.
if os.system("pgrep onvif_srvd > /dev/null") == 0:
    print("Killing previous onvif_srvd instance")
    os.system("sudo pkill onvif_srvd")

# Forcibly terminate.
if os.system("pgrep onvif_srvd > /dev/null") == 0:
    os.system("sudo pkill -9 onvif_srvd")

ip4 = subprocess.check_output(["/sbin/ip", "-o", "-4", "addr", "list", interface]).decode().split()[3].split('/')[0]
os.system("sudo {}/onvif_srvd --ifs {} --scope onvif://www.onvif.org/name/TestDev --scope onvif://www.onvif.org/Profile/S --name RTSP --width 800 --height 600 --url rtsp://{}:8554/stream1 --type MPEG4 --firmware_ver {}".format(directory, interface, ip4, firmware_ver))
os.system("{}/wsdd --if_name {} --type tdn:NetworkVideoTransmitter --xaddr http://{}:1000/onvif/device_service --scope \"onvif://www.onvif.org/name/Unknown onvif://www.onvif.org/Profile/Streaming\"".format(directory, interface, ip4))


