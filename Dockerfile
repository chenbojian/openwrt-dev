FROM openwrtorg/sdk:x86-64-19.07.0

RUN echo "src-git lienol https://github.com/Lienol/openwrt-package" >> feeds.conf.default && \
    echo "src-git lean https://github.com/coolsnowwolf/lede" >> feeds.conf.default
