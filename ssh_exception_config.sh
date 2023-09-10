#!/user/bin/env bash

sudo iptables -t mangle -A OUTPUT -p tcp --sport 22 -j MARK --set-mark 1
sudo ip rule add fwmark 1 table 100
sudo ip route add default via <<ip route | grep default>> dev eth0 table 100
