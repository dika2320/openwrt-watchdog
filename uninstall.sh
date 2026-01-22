#!/bin/ash

echo "[+] Memulai proses Uninstall OpenWrt Watchdog..."

BIN="/usr/bin"
CRON="/etc/crontabs/root"

# 1. Menghapus file script dari sistem
echo "[-] Menghapus file script..."
rm -f "$BIN/reboot_stb.sh"
rm -f "$BIN/interface_watchdog.sh"
rm -f "$BIN/modem_watchdog.sh"

# 2. Menghapus jadwal dari Crontab
if [ -f "$CRON" ]; then
    echo "[-] Menghapus jadwal di Crontab..."
    sed -i '/reboot_stb.sh/d' "$CRON"
    sed -i '/interface_watchdog.sh/d' "$CRON"
    sed -i '/modem_watchdog.sh/d' "$CRON"
fi

# 3. Restart service cron untuk menerapkan perubahan
echo "[+] Restarting Cron service..."
/etc/init.d/cron restart

echo ""
echo "[✓] Uninstall Selesai! Semua script dan jadwal telah dihapus."
