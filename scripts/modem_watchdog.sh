#!/bin/ash

# ================= KONFIGURASI =================
PING1="8.8.8.8"
PING2="1.1.1.1"

INTERFACE="eth1"
USB_PATH="1-1"

CHECK_HOUR="03"        # jam preventive reset
CHECK_MIN_START="00"   # menit mulai
CHECK_MIN_END="05"     # window 5 menit (hindari double reset)

WAIT_AFTER_IF=30
WAIT_AFTER_USB=60

FLAG_3AM="/tmp/modem_reset_3am.done"
# ==============================================

log() {
    logger -t MODEM-WATCHDOG "$1"
}

HOUR_NOW="$(date +%H)"
MIN_NOW="$(date +%M)"

# ===== JALUR 2: RESET JAM 3 PAGI =====
if [ "$HOUR_NOW" = "$CHECK_HOUR" ] && \
   [ "$MIN_NOW" -ge "$CHECK_MIN_START" ] && \
   [ "$MIN_NOW" -le "$CHECK_MIN_END" ] && \
   [ ! -f "$FLAG_3AM" ]; then

    log "Preventive reset modem jam 03:00"
    echo "$USB_PATH" > /sys/bus/usb/drivers/usb/unbind
    sleep 8
    echo "$USB_PATH" > /sys/bus/usb/drivers/usb/bind
    touch "$FLAG_3AM"
    exit 0
fi

# reset flag setelah lewat jam 3
if [ "$HOUR_NOW" != "$CHECK_HOUR" ]; then
    rm -f "$FLAG_3AM"
fi

# ===== JALUR 1: CEK KONEKSI =====
log "Cek koneksi internet..."

ping -c 3 -W 3 $PING1 >/dev/null 2>&1 || \
ping -c 3 -W 3 $PING2 >/dev/null 2>&1

if [ $? -eq 0 ]; then
    log "Internet OK"
    exit 0
fi

log "Internet DOWN, restart interface $INTERFACE"
ifdown $INTERFACE
sleep 5
ifup $INTERFACE
sleep $WAIT_AFTER_IF

ping -c 2 -W 3 $PING1 >/dev/null 2>&1 && exit 0

log "Masih DOWN, reset USB modem ($USB_PATH)"
echo "$USB_PATH" > /sys/bus/usb/drivers/usb/unbind
sleep 8
echo "$USB_PATH" > /sys/bus/usb/drivers/usb/bind
sleep $WAIT_AFTER_USB

log "Proses recovery selesai"
