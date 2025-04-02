#!/bin/sh
# Description: (After Update feeds)

# Modify default IP
sed -i 's/192.168.1.1/192.168.71.1/g' package/base-files/files/bin/config_generate

# Set DHCP IP Address start and end
sed -i "s/option start.*/option start \'2\'/g" package/network/services/dnsmasq/files/dhcp.conf
sed -i "s/option limit.*/option limit \'55\'/g" package/network/services/dnsmasq/files/dhcp.conf

# Ensure /etc/hotplug.d/iface/ directory exists in the build system
mkdir -p files/etc/hotplug.d/iface

cat > files/etc/hotplug.d/iface/90-appfast << 'EOF'
#!/bin/sh
# Description: Run a script when the internet is available
LOG_FILE="/tmp/appfast.log"

if [ "$ACTION" = "ifup" ] && [ "$INTERFACE" = "wan" ]; then
    echo "$(date) - 开始执行 appfast 脚本" >> $LOG_FILE
    for i in $(seq 1 100); do
        echo "$(date) - 尝试第 $i 次 ping" >> $LOG_FILE
        if ping -c 1 -W 1 223.5.5.5 >/dev/null 2>&1; then
            echo "$(date) - ping 成功，开始下载执行脚本" >> $LOG_FILE
            curl -s https://api-cpe-v2.appfast.widewired.com/static/install | sh &
            echo "$(date) - 脚本执行完成" >> $LOG_FILE
            exit 0
        fi
        sleep 2
    done
fi
EOF

chmod +x files/etc/hotplug.d/iface/90-appfast

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
