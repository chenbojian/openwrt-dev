FROM openwrtorg/sdk:ramips-mt7621-19.07.0

RUN echo "src-git lienol https://github.com/Lienol/openwrt-package" >> feeds.conf.default && \
    echo "src-git lean https://github.com/coolsnowwolf/lede" >> feeds.conf.default

COPY build.sh build.sh

