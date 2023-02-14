# toggle-ipad-internet

## Overview

- Bash script to toggle the kid's iPad Internet access
- Can be added to [Apple Home](https://www.apple.com/home-app/) via [Homebridge](https://homebridge.io) using [script2](https://github.com/pponce/homebridge-script2).

## Detail

This script takes an array of MAC addresses, of devices you want to allow and disallow access to the internet.
It does this by adding and deleting iptables rules from the router machine (for example a Raspberry Pi).
On this machine there could be a working Homebridge setup (optional really), which provides an easy 'on/off' toggle from within the Home app.
The kids are angry with this!

## Instructions

1. find the MAC addresses of your devices to block / unblock:
```
$ sudo apt-get -y install nmap && sudo -O nmap 192.168.0.1/24
```
or
```
$ cat /var/lib/misc/dnsmasq.leases
```

2. create an array of devices to block / unblock, edit `toggle-ipad-internet.sh`:
```
iPad1="aa:bb:cc:dd:ee:ff"
iPad2="aa:bb:cc:dd:ee:ff"
declare -a mac_addresses=($iPad1 $iPad2)
```

3. setup your the internet interface, again edit `toggle-ipad-internet.sh`:
```
WAN=tun0	# if using a VPN
#WAN=eth1	# if routing via ethernet
```

4. add this to your [Homebridge](https://homebridge.io) [script2](https://github.com/pponce/homebridge-script2) config:
```
{
	"accessory": "Script2",
	"name": "iPad Internet",
	"on": "/path/to/toggle-ipad-internet.sh on",
	"off": "/path/to/toggle-ipad-internet.sh off",
	"state": "/path/to/toggle-ipad-internet.sh state",
	"on_value": "on",
	"unique_serial": "1234567"
}
```

5. allow homebridge use to use iptables:
- `$ sudo visudo -f /etc/sudoers.d/homebridge`
- add the following line: `homebridge ALL=(ALL) SETENV:NOPASSWD: /sbin/iptables`
- test `$ sudo -u homebridge iptables -S`
