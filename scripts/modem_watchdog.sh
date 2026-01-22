#!/bin/ash

# --- KONFIGURASI ---
PING1="8.8.8.8"
PING2="1.1.1.1"
INTERFACE="eth1"
USB_PATH="1-1"

# Waktu Reset Otomatis
CHECK_HOUR="03"
CHECK_MIN_START="00"
CHECK_MIN_END="05"

# Delay
WAIT_AFTER_IF=30
WAIT_AFTER_USB=60

FLAG_3AM="/tmp/modem_reset_3am.done"
# --------------------

log() {
    logger -t MODEM-WATCHDOG "$1"
    echo "$(date): $1"
}

HOUR_NOW="$(date +%H)"
MIN_NOW="$(date +%M)"

# ===== JALUR 2: PREVENTIVE RESET (JAM 3 PAGI) =====
if [ "$HOUR_NOW" = "$CHECK_HOUR" ] && \
   [ "$MIN_NOW" -ge "$CHECK_MIN_START" ] && \
   [ "$MIN_NOW" -le "$CHECK_MIN_END" ]; then

    if [ ! -f "$FLAG_3AM" ]; then
        log "Preventive reset modem jam 03:00 agar performa optimal."
        echo "$USB_PATH" > /sys/bus/usb/drivers/usb/unbind
        sleep 10
        echo "$USB_PATH" > /sys/bus/usb/drivers/usb/bind
        touch "$FLAG_3AM"
        exit 0
    else
        log "Preventive reset sudah dilakukan, melewati pengecekan."
        exit 0
    fi
fi

# Reset flag jika sudah lewat jam 3 pagi
if [ "$HOUR_NOW" != "$CHECK_HOUR" ] && [ -f "$FLAG_3AM" ]; then
    rm -f "$FLAG_3AM"
fi

# ===== JALUR 1: CEK KONEKSI (WATCHDOG) =====
log "Cek koneksi internet pada $INTERFACE..."

# Melakukan ping, jika berhasil langsung exit
if ping -c 3 -W 3 $PING1 >/dev/null 2>&1 || ping -c 3 -W 3 $PING2 >/dev/null 2>&1; then
    log "Internet OK"
    exit 0
fi

# Jika internet DOWN
log "Internet DOWN, mencoba restart interface $INTERFACE"
ifdown $INTERFACE
sleep 5
ifup $INTERFACE
log "Menunggu $WAIT_AFTER_IF detik setelah ifup..."
sleep $WAIT_AFTER_IF

# Cek lagi setelah restart interface
if ping -c 2 -W 3 $PING1 >/dev/null 2>&1; then
    log "Internet OK setelah restart interface."
    exit 0
fi

# Jika masih DOWN, lakukan Hard Reset via USB Unbind
log "Masih DOWN, melakukan HARD RESET USB modem ($USB_PATH)"
echo "$USB_PATH" > /sys/bus/usb/drivers/usb/unbind
sleep 10
echo "$USB_PATH" > /sys/bus/usb/drivers/usb/bind

log "Recovery selesai, menunggu modem inisialisasi ($WAIT_AFTER_USB detik)..."
sleep $WAIT_AFTER_USB
