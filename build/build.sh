#!/bin/bash
set -e

./scripts/feeds update -a
make defconfig

./scripts/feeds install dns2socks
make package/dns2socks/{clean,compile} -j$(nproc) V=sc
