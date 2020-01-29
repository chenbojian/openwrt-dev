#!/bin/sh

url_main="https://raw.githubusercontent.com/hq450/fancyss/master/rules"

wget --timeout=8 "$url_main"/gfwlist.conf -O /root/gfwlist.conf

sed -i "s/gfwlist$/ss_rules_dst_forward/g" /root/gfwlist.conf
