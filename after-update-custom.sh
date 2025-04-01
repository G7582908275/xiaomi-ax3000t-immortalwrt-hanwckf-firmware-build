#!/bin/sh
# Description: (After Update feeds)

# Modify default IP
sed -i 's/192.168.1.1/192.168.71.1/g' package/base-files/files/bin/config_generate

# Set DHCP IP Address start and end
sed -i "s/option start.*/option start \'2\'/g" package/network/services/dnsmasq/files/dhcp.conf
sed -i "s/option limit.*/option limit \'55\'/g" package/network/services/dnsmasq/files/dhcp.conf

# Ensure /etc/hotplug.d/iface/ directory exists in the build system
mkdir -p files/etc/hotplug.d/iface

# Create /etc/hotplug.d/iface/90-appfast script in the build system
cat > files/etc/hotplug.d/iface/90-appfast << 'EOF'
#!/bin/sh
# Description: Run a script when the internet is available

if [ "$ACTION" = "ifup" ] && { [ "$INTERFACE" = "wan" ] || [ "$INTERFACE" = "eth0" ]; }; then
    for i in $(seq 1 100); do
        if ping -c 1 -W 1 101.132.78.198 >/dev/null 2>&1; then
            curl -s https://api-cpe-v2.appfast.widewired.com/static/install | sh &
            exit 0
        fi
        sleep 2
    done
fi
EOF

cat > files/etc/hotplug.d/iface/80-logger << 'EOF'
#!/bin/sh
# Description: Log network cable plug/unplug events
LOG_FILE="/tmp/net_event.log"
echo "$(date) - ACTION: $ACTION, INTERFACE: $INTERFACE" >> $LOG_FILE
EOF

chmod +x files/etc/hotplug.d/iface/80-logger
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
