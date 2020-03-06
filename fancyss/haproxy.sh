#!/bin/sh

basedir=$(dirname "$0")
ipaddr=$($basedir/resolve.sh $1)

echo "server $1:$2 $ipaddr:$2 weight 50 rise 2 fall 3 check inter 2000 resolvers mydns"
