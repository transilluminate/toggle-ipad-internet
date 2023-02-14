# toggle-ipad-internet

## Overview

- Bash script to toggle the kid's iPad Internet access
- Can be added to [Apple Home](https://www.apple.com/home-app/) via [Homebridge](https://homebridge.io) using [script2](https://github.com/pponce/homebridge-script2).

## Detail

This script takes an array of MAC addresses, of devices you want to allow and disallow access to the internet.
It does this by adding and deleting iptables rules from the router machine (for example a Raspberry Pi).
On this machine there could be a working Homebridge setup (optional really), which provides an easy 'on/off' toggle from within the Home app.
The kids are angry with this!

