#!/bin/bash

base_dir=$(dirname "$0")

add_source() {
    local file=$base_dir/feeds.conf.default
    if ! grep -q -F "$1" "$file"; then
        echo "$1" >> $file
    fi
}

add_source "src-git lienol https://github.com/Lienol/openwrt-package"
add_source "src-git lean https://github.com/coolsnowwolf/lede"

./scripts/feeds update -a
make defconfig

./scripts/feeds install dns2socks
make package/dns2socks/{clean,compile} -j$(nproc)
