#!/bin/bash
set -eu
echo "[-] delete old files..."
rm -f ./resources/Country.mmdb
rm -rf ./resources/clashxdashboard
rm -rf ./resources/yacddashboard
rm -f GeoLite2-Country.*
echo "[+] install mmdb..."
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
tar -zxvf GeoLite2-Country.tar.gz
mv GeoLite2-Country_*/GeoLite2-Country.mmdb ./resources/Country.mmdb
rm GeoLite2-Country.tar.gz
rm -r GeoLite2-Country_*
echo "[+] install clashx dashboard..."
cd resources
git clone -b gh-pages https://github.com/Dreamacro/clash-dashboard.git clashxdashboard
echo "[+] install yacd dashboard..."
git clone -b gh-pages https://github.com/haishanh/yacd.git yacddashboard
cd ..
