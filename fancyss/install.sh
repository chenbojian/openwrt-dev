#!/bin/sh

base_dir=$(dirname "$0")

DNS2SOCKS_URL="https://github.com/chenbojian/openwrt-dev/releases/download/0.0.1/dns2socks_2.0-20150628_$(uname -m).ipk"

opkg update
opkg install ca-bundle ca-certificates libustream-mbedtls
opkg install curl ipset \
             shadowsocks-libev-ss-local \
             shadowsocks-libev-ss-redir \
             shadowsocks-libev-ss-rules \
             shadowsocks-libev-ss-server \
             shadowsocks-libev-ss-tunnel
wget "$DNS2SOCKS_URL" -O dns2socks.ipk
opkg install dns2socks.ipk

opkg remove dnsmasq && opkg install dnsmasq-full || true

cp -f $base_dir/ss.json.template /etc/ss.json

