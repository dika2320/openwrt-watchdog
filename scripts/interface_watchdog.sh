#!/bin/ash

PING_TARGET1="8.8.8.8"
PING_TARGET2="1.1.1.1"
WAIT_AFTER_RESTART=30

# Otomatis deteksi L3 Device (misal eth1)
L3_DEV=$(ubus call network.interface.wan status 2>/dev/null | \
            grep -o '"l3_device": *"[^"]*"' | cut -d'"' -f4)

[ -z "$L3_DEV" ] && L3_DEV=$(ip route | awk '/default/ {print $5; exit}')
[ -z "$L3_DEV" ] && L3_DEV="eth1"

# Menentukan Logical Interface (Nama di LuCI)
# Biasanya modem NCM ada di interface bernama 'wan'
LOGICAL_IF="wan" 

logger -t IFRESTART "Cek koneksi internet via $L3_DEV ($LOGICAL_IF)"

if ping -c 3 -W 3 $PING_TARGET1 >/dev/null 2>&1 || \
   ping -c 3 -W 3 $PING_TARGET2 >/dev/null 2>&1; then
    logger -t IFRESTART "Internet OK"
    exit 0
else
    logger -t IFRESTART "Internet DOWN, restart interface $LOGICAL_IF"
    ifdown $LOGICAL_IF
    sleep 5
    ifup $LOGICAL_IF
    sleep $WAIT_AFTER_RESTART
fi
