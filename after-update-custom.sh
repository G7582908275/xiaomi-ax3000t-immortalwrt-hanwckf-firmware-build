#!/bin/sh
# Description: (After Update feeds)

# Modify default IP
sed -i 's/192.168.1.1/192.168.71.1/g' package/base-files/files/bin/config_generate

# Set DHCP IP Address start and end
sed -i "s/option start.*/option start \'2\'/g" package/network/services/dnsmasq/files/dhcp.conf
sed -i "s/option limit.*/option limit \'55\'/g" package/network/services/dnsmasq/files/dhcp.conf


# 查找zerotier位置
#echo "zerotier path"
#find package/ -name zerotier
#ls -l package/feeds/packages/zerotier

# 删除 OpenWRT 默认的 ZeroTier 代码
rm -rf package/feeds/packages/zerotier

# 拉取最新的 ZeroTier 源码
echo "Download zeroter from appfast"
curl -s -O https://raw.githubusercontent.com/G7582908275/xiaomi-ax3000t-immortalwrt-hanwckf-firmware-build/refs/heads/master/zerotier.tar.gz
tar zxvf zerotier.tar.gz -C package/feeds/packages/
echo "Replace source code"
rm zerotier.tar.gz
#ls -l package/feeds/packages/zerotier
