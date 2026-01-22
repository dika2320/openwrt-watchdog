# OpenWrt Watchdog & Auto Reboot

Script otomatis untuk menjaga stabilitas koneksi internet pada STB OpenWrt, khususnya untuk pengguna Modem Rakitan dengan protokol **NCM**. Script ini memantau interface, melakukan reset USB jika modem hang, dan melakukan reboot STB secara terjadwal.

## ✨ Fitur
- **Auto Detect Interface:** Mendeteksi interface WAN secara otomatis.
- **Interface Watchdog:** Restart interface jika ping ke internet gagal.
- **Modem Watchdog (NCM):** Melakukan *Hard Reset* via USB Unbind/Bind jika modem tidak merespons (spesifik Port USB 1-1).
- **Scheduled Reboot:** Menjaga performa STB dengan reboot otomatis setiap subuh.
- **Installer Interaktif:** Pengguna bisa menentukan jam reboot dan interval pengecekan sendiri.

## 🚀 Cara Instalasi

Pilih salah satu perintah di bawah ini sesuai dengan shell yang Anda gunakan di STB:

### Jalur ASH (Standar OpenWrt)
```bash
ash -c "$(wget -qO- [https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh](https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh))"

```

### Jalur BASH (Opsional)

```bash
bash -c "$(wget -qO- [https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh](https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh))"

```

---

## 🗑️ Cara Uninstall

Jika ingin menghapus semua script dan jadwal crontab dari sistem:

### Jalur ASH (Standar OpenWrt)

```bash
ash -c "$(wget -qO- [https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/uninstall.sh](https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/uninstall.sh))"

```

### Jalur BASH (Opsional)

```bash
bash -c "$(wget -qO- [https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/uninstall.sh](https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/uninstall.sh))"

```

---

## 📁 Struktur File

* `install.sh`: Script penginstal otomatis.
* `uninstall.sh`: Script penghapus otomatis.
* `scripts/reboot_stb.sh`: Script reboot terjadwal.
* `scripts/interface_watchdog.sh`: Script pemantau koneksi interface.
* `scripts/modem_watchdog.sh`: Script hard reset USB modem (Unbind/Bind).

## 📊 Cara Monitoring

Anda bisa melihat log aktivitas watchdog melalui terminal dengan perintah:

```bash
logread | grep -E "MODEM-WATCHDOG|IFRESTART|REBOOT"

```

---

**Catatan:** Pastikan modem Anda berada pada port USB yang sesuai (`1-1`). Jika berbeda, Anda dapat menyesuaikan variabel `USB_PATH` pada file `modem_watchdog.sh` setelah instalasi di folder `/usr/bin/`.

