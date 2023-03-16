#!/bin/python3

from datetime import datetime
import os
import subprocess
import json
import sys

SUPPORTED_MODES = ["dhcp"]

MODE = os.getenv("CONFIGURE_NETWORK_MODE") or "dhcp"

if MODE not in SUPPORTED_MODES:
    modes_str = "', '".join(SUPPORTED_MODES)
    print(f"invalid mode '{MODE}' supported modes: '{modes_str}'", file=sys.stderr)
    sys.exit(4)

ip_address_result = subprocess.run(
    ["/sbin/ip", "--json", "address"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT
)
if ip_address_result.returncode != 0:
    print(f"/sbin/ip: {ip_address_result.stdout}", file=sys.stderr)
    sys.exit(2)

ip_devices = json.loads(ip_address_result.stdout)

ethernet_device_obj = None
for dev in ip_devices:
    if dev["link_type"] == "ether":
        ethernet_device_obj = dev
        break

if ethernet_device_obj == None:
    print("no ethernet device found", file=sys.stderr)
    sys.exit(3)


ethernet_device_name = ethernet_device_obj["ifname"]
config_lines = []
if MODE == "dhcp":
    config_lines = [
        f"\nauto {ethernet_device_name}",
        f"\nallow-hotplug {ethernet_device_name}",
        f"\niface {ethernet_device_name} inet dhcp\n",
    ]
else:
    print(f"invalid mode '{MODE}' supported modes: '{modes_str}'", file=sys.stderr)
    sys.exit(4)

with open("/etc/network/interfaces", "a") as f:
    now = datetime.utcnow().isoformat()
    lines = [f"\n\n# Configured by debian/configure-network.py at {now}"]
    lines.extend(config_lines)
    f.writelines(lines)
