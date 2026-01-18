#!/bin/ash

PING_TARGET1="8.8.8.8"
PING_TARGET2="1.1.1.1"
INTERFACE="eth1"
WAIT_AFTER_RESTART=30

logger -t IFRESTART "Cek koneksi internet via $INTERFACE"

ping -c 3 -W 3 $PING_TARGET1 >/dev/null 2>&1 || \
ping -c 3 -W 3 $PING_TARGET2 >/dev/null 2>&1

if [ $? -ne 0 ]; then
    logger -t IFRESTART "Internet DOWN, restart interface $INTERFACE"
    ifdown $INTERFACE
    sleep 5
    ifup $INTERFACE
    sleep $WAIT_AFTER_RESTART
else
    logger -t IFRESTART "Internet OK"
fi
