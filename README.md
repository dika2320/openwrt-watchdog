# OpenWrt Watchdog

OpenWrt Watchdog adalah kumpulan script sederhana untuk **menjaga koneksi internet tetap stabil** pada perangkat OpenWrt (STB / router), khususnya yang menggunakan **modem USB Huawei (NCM)**.

Project ini cocok untuk:
- STB OpenWrt (HG680P, B860H, dll)
- Jaringan RT/RW
- Modem USB yang rawan freeze / loss koneksi

---

## ✨ Fitur

- 🔁 **Auto restart interface** (contoh: `eth1`) saat koneksi terputus
- 📶 **Auto reset modem Huawei (NCM)** ketika internet loss
- 🔄 **Auto reboot STB terjadwal** (default jam **03:00**)
- 🛡️ **Anti bootloop** (delay & kontrol via cron)
- ⏱️ **Cron otomatis** (tidak perlu setting manual)

---

## 📦 Cara Install

Install:
```sh
=================================================================================================================

BASH:
bash -c "$(wget -qO - https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh)"

CURL:
sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh)"

UNISTALL:
sh -c "$(wget -qO - https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/uninstall.sh)"

=================================================================================================================



