#!/bin/ash

echo "[!] OpenWrt Watchdog Uninstaller"

BIN="/usr/bin"
CRON="/etc/crontabs/root"


if [ -f "$CRON" ]; then
    sed -i '/modem_watchdog.sh/d' "$CRON"
    sed -i '/reboot_stb.sh/d' "$CRON"
    sed -i '/if_restart.sh/d' "$CRON"
    echo "[✓] Cron watchdog dibersihkan"
else
    echo "[!] Crontab tidak ditemukan"
fi


if [ -f "$BIN/modem_watchdog.sh" ]; then
    rm -f "$BIN/modem_watchdog.sh"
    echo "[✓] modem_watchdog.sh dihapus"
else
    echo "[i] modem_watchdog.sh tidak ditemukan"
fi

if [ -f "$BIN/reboot_stb.sh" ]; then
    rm -f "$BIN/reboot_stb.sh"
    echo "[✓] reboot_stb.sh dihapus"
else
    echo "[i] reboot_stb.sh tidak ditemukan"
fi

if [ -f "$BIN/if_restart.sh" ]; then
    rm -f "$BIN/if_restart.sh"
    echo "[✓] if_restart.sh dihapus"
fi


/etc/init.d/cron restart
sync

echo "[✓] OpenWrt Watchdog berhasil di-uninstall"
