#!/bin/sh

config_file=/etc/ss.json
ss_redir_port=3333
ss_local_port=3334
dns_port=7913

start() {
    ss-local -l $ss_local_port -c $config_file -f /var/run/ss-local.pid >/dev/null 2>&1
    ss-redir -l $ss_redir_port -c $config_file -f /var/run/ss-redir.pid >/dev/null 2>&1
    dns2socks "127.0.0.1:$ss_local_port" 8.8.8.8 "127.0.0.1:$dns_port" >/dev/null 2>&1 &
    config_dnsmasq
    ss-rules -l $ss_redir_port
    ps |grep -E "ss-local|ss-redir|dns2socks"
}

stop() {
    ss-rules -f
    reset_dnsmasq
    kill_process dns2socks
    kill_process ss-redir
    kill_process ss-local
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
    process=$(pidof $1)
    if [ -n "$process" ]; then
		echo "关闭$1进程..."
		killall $1 >/dev/null 2>&1
		kill -9 "$process" >/dev/null 2>&1
	fi
}

case $1 in
start)
    stop
    start
    ;;
stop)
    stop
    ;;
esac