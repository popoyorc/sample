#!/bin/bash

NIC=$(netstat -r | awk '/default/ {print $NF}' | head -1)
dhclient -r $NIC
dhclient $NIC
notify-send "Your new IP is $(ip addr show $NIC | awk '/inet/ {print $2}')"
