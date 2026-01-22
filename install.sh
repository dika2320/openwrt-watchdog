#!/bin/ash

echo "[+] OpenWrt Watchdog Installer"

# Pastikan URL sesuai dengan struktur folder di GitHub Anda
BASE_URL="https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main"
BIN="/usr/bin"
CRON="/etc/crontabs/root"

# Buat direktori bin jika belum ada (antisipasi sistem custom)
mkdir -p $BIN

echo ""
echo "--- Konfigurasi Auto Reboot STB ---"
printf "Jam reboot STB (0-23) [default: 3]: "
read REBOOT_HOUR
REBOOT_HOUR=${REBOOT_HOUR:-3}

printf "Menit reboot STB (0-59) [default: 0]: "
read REBOOT_MIN
REBOOT_MIN=${REBOOT_MIN:-0}

echo ""
echo "--- Konfigurasi Watchdog Interface ---"
printf "Interval cek interface (menit) [default: 5]: "
read IF_INTERVAL
IF_INTERVAL=${IF_INTERVAL:-5}

# Deteksi Modem NCM
HAS_NCM=0
if lsmod | grep -Eq "cdc_ncm|huawei_cdc_ncm"; then
    HAS_NCM=1
fi

if [ "$HAS_NCM" -eq 1 ]; then
    echo "[✓] Modem NCM terdeteksi"
    printf "Interval cek modem NCM (menit) [default: 5]: "
    read MODEM_INTERVAL
    MODEM_INTERVAL=${MODEM_INTERVAL:-5}
else
    echo "[!] Modem NCM tidak terdeteksi, modem watchdog dilewati"
fi

echo ""
echo "[+] Mengunduh script..."

# Fungsi download dengan verifikasi
download_script() {
    local name=$1
    local target=$2
    echo "Sedang mengunduh $name..."
    # Menghapus file lama jika ada agar tidak tertumpuk .1 .2
    rm -f "$target"
    wget -q --no-check-certificate -O "$target" "$BASE_URL/scripts/$name"
    
    if [ -f "$target" ]; then
        chmod +x "$target"
        echo "[✓] $name berhasil dipasang."
    else
        echo "[X] Gagal mengunduh $name! Cek folder 'scripts' di GitHub Anda."
    fi
}

download_script "reboot_stb.sh" "$BIN/reboot_stb.sh"
download_script "interface_watchdog.sh" "$BIN/interface_watchdog.sh"

if [ "$HAS_NCM" -eq 1 ]; then
    download_script "modem_watchdog.sh" "$BIN/modem_watchdog.sh"
fi

# Bersihkan crontab lama agar tidak duplikat
echo "[+] Mengatur ulang Crontab..."
touch $CRON
sed -i '/reboot_stb.sh/d' $CRON
sed -i '/interface_watchdog.sh/d' $CRON
sed -i '/modem_watchdog.sh/d' $CRON

# Tambahkan jadwal baru
echo "*/$IF_INTERVAL * * * * $BIN/interface_watchdog.sh" >> $CRON
echo "$REBOOT_MIN $REBOOT_HOUR * * * $BIN/reboot_stb.sh" >> $CRON

if [ "$HAS_NCM" -eq 1 ] && [ -f "$BIN/modem_watchdog.sh" ]; then
    echo "*/$MODEM_INTERVAL * * * * $BIN/modem_watchdog.sh" >> $CRON
fi

# Restart Cron agar perubahan aktif
/etc/init.d/cron restart

echo ""
echo "[✓] INSTALASI SELESAI"
echo "    - Reboot STB        : Jam $REBOOT_HOUR:$REBOOT_MIN"
echo "    - Watchdog Interface: Tiap $IF_INTERVAL menit"
[ "$HAS_NCM" -eq 1 ] && echo "    - Watchdog Modem NCM: Tiap $MODEM_INTERVAL menit"
