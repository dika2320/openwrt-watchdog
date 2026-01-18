#!/bin/ash

echo "[!] OpenWrt Watchdog Uninstaller"

BIN="/usr/bin"
CRON="/etc/crontabs/root"

if [ -f "$CRON" ]; then
    sed -i '/modem_watchdog.sh/d' "$CRON"
    sed -i '/reboot_stb.sh/d' "$CRON"
    echo "[✓] Cron watchdog dihapus"
else
    echo "[!] Crontab tidak ditemukan"
fi

if [ -f "$BIN/modem_watchdog.sh" ]; then
    rm -f "$BIN/modem_watchdog.sh"
    echo "[✓] modem_watchdog.sh dihapus"
fi

if [ -f "$BIN/reboot_stb.sh" ]; then
    rm -f "$BIN/reboot_stb.sh"
    echo "[✓] reboot_stb.sh dihapus"
fi

/etc/init.d/cron restart

echo "[✓] Uninstall selesai"
