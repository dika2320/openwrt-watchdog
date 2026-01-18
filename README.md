# OpenWrt Watchdog

OpenWrt Watchdog adalah kumpulan script sederhana untuk **menjaga koneksi internet tetap stabil**
pada perangkat **OpenWrt (STB / router)**.

Project ini **fleksibel & aman untuk repo public**, karena **tidak memaksa semua user memakai modem USB NCM**.

---

## 🎯 Cocok Untuk

- STB OpenWrt (HG680P, B860H, dll)
- Router OpenWrt
- Jaringan RT/RW / hotspot
- Modem USB (Huawei / non-Huawei)
- Koneksi WAN yang sering drop / freeze

---

## ✨ Fitur Utama

### 🔄 Watchdog Interface (Universal)
- Auto restart **interface WAN yang aktif**
- **Tidak hardcode nama interface**
- Script akan **mencari interface UP secara otomatis**
- Cocok untuk:
  - Modem USB
  - Ethernet
  - Tethering HP
  - PPP / DHCP / NCM

> ✅ Fitur ini **SELALU aktif** di semua perangkat

---

### 📶 Watchdog Modem USB (Opsional & Otomatis)
- **Hanya diaktifkan jika modem NCM terdeteksi**
- Deteksi berdasarkan kernel module:
  - `cdc_ncm`
  - `huawei_cdc_ncm`
- Jika **bukan modem NCM**:
  - Script modem **tidak di-install**
  - Tidak ada cron modem
  - Sistem tetap aman & ringan

> ❌ Tidak ada error meskipun modem tidak mendukung NCM

---

### 🔁 Auto Reboot STB Terjadwal
- Reboot otomatis harian
- Default: **jam 03:00**
- Bisa diubah saat install
- Berguna untuk:
  - Membersihkan cache
  - Mencegah freeze jangka panjang

---

### 🛡️ Aman & Anti Bootloop
- Semua proses dijalankan via **cron**
- Tidak menggunakan loop background
- Delay & pengecekan aman
- Tidak menyebabkan reboot berulang

---

## ⚙️ Cara Kerja Singkat

| Kondisi Perangkat | Yang Diaktifkan |
|------------------|----------------|
| Semua OpenWrt | Watchdog Interface + Reboot STB |
| Modem NCM terdeteksi | + Watchdog Modem |
| Bukan modem NCM | Modem watchdog dilewati |

---

## 📦 Cara Install

Jalankan di OpenWrt (via SSH):

```sh
wget https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh
chmod +x install.sh
./install.sh


UNISTALL:
sh -c "$(wget -qO - https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/uninstall.sh)"

=================================================================================================================



