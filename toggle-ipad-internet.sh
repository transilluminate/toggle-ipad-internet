#!/bin/bash
# Copyright 2023 Adrian Robinson <adrian dot j dot robinson at gmail dot com>
# https://github.com/transilluminate/toggle-ipad-internet

# find the MAC addresses of your devices to block/unblock:
#	$ sudo apt-get -y install nmap && sudo -O nmap 192.168.0.1/24
# 	$ cat /var/lib/misc/dnsmasq.leases

# devices to block / unblock
iPad1="aa:bb:cc:dd:ee:ff"
iPad2="aa:bb:cc:dd:ee:ff"
declare -a mac_addresses=($iPad1 $iPad2)

# internet interface:
WAN=tun0
#WAN=eth1

# add this to homebridge script2 config:
#	{
#	    "accessory": "Script2",
#	    "name": "iPad Internet",
#	    "on": "/path/to/toggle-ipad-internet.sh on",
#	    "off": "/path/to/toggle-ipad-internet.sh off",
#	    "state": "/path/to/toggle-ipad-internet.sh state",
#	    "on_value": "on",
#	    "unique_serial": "1234567"
#	}

# allow homebridge use to use iptables:
#	$ sudo visudo -f /etc/sudoers.d/homebridge
# add the following line:
#	homebridge ALL=(ALL) SETENV:NOPASSWD: /sbin/iptables
# test:
#	$ sudo -u homebridge iptables -S

off()
{
  for mac_address in "${mac_addresses[@]}"; do
    if [ $(sudo iptables -S | grep -c "$mac_address") -eq 0 ]; then
      sudo iptables -I FORWARD 1 -m mac --mac-source $mac_address -o $WAN -j REJECT
    fi
  done
}

on()
{
  for mac_address in "${mac_addresses[@]}"; do
    if [ $(sudo iptables -S | grep -c "$mac_address") -gt 0 ]; then
      sudo iptables -D FORWARD -m mac --mac-source $mac_address -o $WAN -j REJECT
    fi
  done
}

state()
{
  # the rest of the iptables rules are allow, it's a simple check
  status=$(sudo iptables -S | grep -c "REJECT")
  if [ $status -eq 0 ]; then
     echo "on"
  else
     echo "off"
  fi
}

case "${1}" in
  on)
    on
    ;;
  off)
    off
    ;;
  state)
    state
    ;;
  *)
    echo "Usage: $0 {on|off|state}" >&2
    exit 1
    ;;
esac
exit 0
