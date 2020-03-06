#!/bin/sh

echo $(nslookup $1 | grep -E "Address( 1)?: \d+\.\d+\.\d+\.\d+" | sed -E "s/Address( 1)?: //g")
