#!/bin/ash

echo "[+] OpenWrt Watchdog Installer"

BASE_URL="https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main"
BIN="/usr/bin"
CRON="/etc/crontabs/root"

echo ""
echo "Konfigurasi Auto Reboot STB"
printf "Jam reboot STB (0-23) [default: 3]: "
read REBOOT_HOUR
REBOOT_HOUR=${REBOOT_HOUR:-3}

printf "Menit reboot STB (0-59) [default: 0]: "
read REBOOT_MIN
REBOOT_MIN=${REBOOT_MIN:-0}

echo ""
echo "Konfigurasi Watchdog Modem"
printf "Interval cek modem (menit) [default: 5]: "
read MODEM_INTERVAL
MODEM_INTERVAL=${MODEM_INTERVAL:-5}


wget -qO $BIN/modem_watchdog.sh "$BASE_URL/scripts/modem_watchdog.sh"
wget -qO $BIN/reboot_stb.sh "$BASE_URL/scripts/reboot_stb.sh"

chmod +x $BIN/modem_watchdog.sh
chmod +x $BIN/reboot_stb.sh


sed -i '/modem_watchdog.sh/d' $CRON
sed -i '/reboot_stb.sh/d' $CRON


echo "*/$MODEM_INTERVAL * * * * $BIN/modem_watchdog.sh" >> $CRON
echo "$REBOOT_MIN $REBOOT_HOUR * * * $BIN/reboot_stb.sh" >> $CRON

/etc/init.d/cron restart

echo ""
echo "[✓] Instalasi selesai"
echo "    - Watchdog modem: tiap $MODEM_INTERVAL menit"
echo "    - Reboot STB    : $REBOOT_HOUR:$REBOOT_MIN"
