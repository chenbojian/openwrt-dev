#!/bin/bash

# build/docker-run.sh ramips-mt7621
# build/docker-run.sh

BASEDIR="$(cd "$(dirname "$0")"; pwd)"

TARGET="${1:-x86-64}"
BRANCH="${2:-19.07.0}"

docker run -v "$(pwd)/bin":/home/build/openwrt/bin \
           -v "$BASEDIR/build.sh":/home/build/openwrt/build.sh \
           -it --rm openwrtorg/sdk:$TARGET-$BRANCH
