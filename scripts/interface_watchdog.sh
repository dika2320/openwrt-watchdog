#!/bin/ash

PING_TARGET1="8.8.8.8"
PING_TARGET2="1.1.1.1"
WAIT_AFTER_RESTART=30


INTERFACE=$(ubus call network.interface.wan status 2>/dev/null | \
            grep -o '"l3_device": *"[^"]*"' | cut -d'"' -f4)


[ -z "$INTERFACE" ] && INTERFACE=$(ip route | awk '/default/ {print $5; exit}')


[ -z "$INTERFACE" ] && INTERFACE="eth1"

logger -t IFRESTART "Cek koneksi internet via $INTERFACE"

ping -c 3 -W 3 $PING_TARGET1 >/dev/null 2>&1 || \
ping -c 3 -W 3 $PING_TARGET2 >/dev/null 2>&1

if [ $? -ne 0 ]; then
    logger -t IFRESTART "Internet DOWN, restart interface $INTERFACE"


    ifdown wan
    sleep 5
    ifup wan

    sleep $WAIT_AFTER_RESTART
else
    logger -t IFRESTART "Internet OK"
fi
