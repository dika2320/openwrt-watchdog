## OpenWrt Watchdog

Fitur:
- Auto restart interface (eth1)
- Auto reset modem Huawei NCM
- Auto reboot STB jam 03:00
- Anti bootloop
- Cron otomatis

Install:
```sh
=================================================================================================================

BASH:
bash -c "$(wget -qO - https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh)"

CURL:
sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/dika2320/openwrt-watchdog@main/install.sh)"


=================================================================================================================



