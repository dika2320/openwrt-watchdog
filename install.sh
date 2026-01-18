#!/bin/ash

echo "[+] OpenWrt Watchdog Installer"

BASE_URL="https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main"
BIN="/usr/bin"
CRON="/etc/crontabs/root"

wget -qO $BIN/modem_watchdog.sh "$BASE_URL/scripts/modem_watchdog.sh"
wget -qO $BIN/reboot_stb.sh "$BASE_URL/scripts/reboot_stb.sh"

chmod +x $BIN/modem_watchdog.sh
chmod +x $BIN/reboot_stb.sh

sed -i '/modem_watchdog.sh/d' $CRON
sed -i '/reboot_stb.sh/d' $CRON

echo "*/5 * * * * $BIN/modem_watchdog.sh" >> $CRON
echo "0 3 * * * $BIN/reboot_stb.sh" >> $CRON

/etc/init.d/cron restart

echo "[✓] Done"
