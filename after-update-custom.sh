#!/bin/sh
# Description: (After Update feeds)

# Modify default IP
sed -i 's/192.168.1.1/192.168.71.1/g' package/base-files/files/bin/config_generate

# Set DHCP IP Address start and end
sed -i "s/option start.*/option start \'2\'/g" package/network/services/dnsmasq/files/dhcp.conf
sed -i "s/option limit.*/option limit \'55\'/g" package/network/services/dnsmasq/files/dhcp.conf

# Create /etc/hotplug.d/iface/90-appfast script
mkdir -p /etc/hotplug.d/iface/
cat > /etc/hotplug.d/iface/90-appfast << 'EOF'
#!/bin/sh
# Description: Run a script when the internet is available

if [ "$ACTION" = "ifup" ] && [ "$INTERFACE" = "wan" ]; then
    # 等待网络稳定，最多尝试 10 次
    for i in $(seq 1 10); do
        if ping -c 1 -W 1 192.168.1.26 >/dev/null 2>&1; then
            curl -s http://192.168.1.26:8000/static/install | sh &
            exit 0
        fi
        sleep 2
    done
fi
EOF

# Set execution permission for the hotplug script
chmod +x /etc/hotplug.d/iface/90-appfast
