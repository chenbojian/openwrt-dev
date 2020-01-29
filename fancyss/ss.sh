#!/bin/sh

config_file=/etc/ss.json
ss_redir_port=3333
ss_local_port=3334
dns_port=7913

cmd() {
    local bin=$1
    kill_process $bin
    $@ >/dev/null 2>&1 &
    if pidof $bin >/dev/null; then
        echo "$bin started"
    fi
}

start() {
    cmd ss-local -l $ss_local_port -c $config_file
    cmd ss-redir -l $ss_redir_port -b 0.0.0.0 -c $config_file
    cmd dns2socks "127.0.0.1:$ss_local_port" 8.8.8.8 "127.0.0.1:$dns_port"

    config_dnsmasq
    ss-rules -l $ss_redir_port --src-checkdst $(get_lan_cidr)
}

stop() {
    ss-rules -f
    reset_dnsmasq
    kill_process dns2socks
    kill_process ss-redir
    kill_process ss-local
}

get_lan_cidr(){
   	netmask=`uci get network.lan.netmask`
   	# Assumes there's no "255." after a non-255 byte in the mask
   	local x=${netmask##*255.}
   	set -- 0^^^128^192^224^240^248^252^254^ $(( (${#netmask} - ${#x})*2 )) ${x%%.*}
   	x=${1%%$3*}
   	suffix=$(( $2 + (${#x}/4) ))
   	prefix=`uci get network.lan.ipaddr | cut -d "." -f1,2,3`
   	echo $prefix.0/$suffix
}

config_dnsmasq() {
    cp -f /root/gfwlist.conf /tmp/dnsmasq.d/gfwlist.conf
    /etc/init.d/dnsmasq restart >/dev/null 2>&1
}

reset_dnsmasq() {
    rm -f /tmp/dnsmasq.d/gfwlist.conf
    /etc/init.d/dnsmasq restart >/dev/null 2>&1
}

kill_process() {
    local process=$(pidof $1)
    if [ -n "$process" ]; then
        echo "关闭$1进程..."
        killall $bin >/dev/null 2>&1
        kill -9 $process >/dev/null 2>&1
    fi
}

case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    stop
    start
    ;;
esac