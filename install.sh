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
echo "Konfigurasi Watchdog Interface"
printf "Interval cek interface (menit) [default: 5]: "
read IF_INTERVAL
IF_INTERVAL=${IF_INTERVAL:-5}

HAS_NCM=0
if lsmod | grep -Eq "cdc_ncm|huawei_cdc_ncm"; then
    HAS_NCM=1
fi

if [ "$HAS_NCM" -eq 1 ]; then
    echo ""
    echo "[✓] Modem NCM terdeteksi"
    printf "Interval cek modem NCM (menit) [default: 5]: "
    read MODEM_INTERVAL
    MODEM_INTERVAL=${MODEM_INTERVAL:-5}
else
    echo ""
    echo "[!] Modem NCM tidak terdeteksi, modem watchdog dilewati"
fi

echo ""
echo "[+] Mengunduh script..."

wget -qO $BIN/reboot_stb.sh "$BASE_URL/scripts/reboot_stb.sh"
wget -qO $BIN/interface_watchdog.sh "$BASE_URL/scripts/interface_watchdog.sh"

chmod +x $BIN/reboot_stb.sh
chmod +x $BIN/interface_watchdog.sh

if [ "$HAS_NCM" -eq 1 ]; then
    wget -qO $BIN/modem_watchdog.sh "$BASE_URL/scripts/modem_watchdog.sh"
    chmod +x $BIN/modem_watchdog.sh
fi

sed -i '/reboot_stb.sh/d' $CRON
sed -i '/interface_watchdog.sh/d' $CRON
sed -i '/modem_watchdog.sh/d' $CRON

echo "*/$IF_INTERVAL * * * * $BIN/interface_watchdog.sh" >> $CRON
echo "$REBOOT_MIN $REBOOT_HOUR * * * $BIN/reboot_stb.sh" >> $CRON

if [ "$HAS_NCM" -eq 1 ]; then
    echo "*/$MODEM_INTERVAL * * * * $BIN/modem_watchdog.sh" >> $CRON
fi

/etc/init.d/cron restart

echo ""
echo "[✓] Instalasi selesai"
echo "    - Reboot STB        : $REBOOT_HOUR:$REBOOT_MIN"
echo "    - Watchdog Interface: tiap $IF_INTERVAL menit"

if [ "$HAS_NCM" -eq 1 ]; then
    echo "    - Watchdog Modem NCM: tiap $MODEM_INTERVAL menit"
else
    echo "    - Watchdog Modem    : tidak dipasang"
fi
