# Description: (Before Update feeds)


# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> ./feeds.conf.default   
# echo "src-git small https://github.com/kenzok8/small" >> ./feeds.conf.default

# 方法1
# echo "src-git zerotier https://github.com/zerotier/ZeroTierOne.git" >> ./feeds.conf.default

# 方法2
#rm -rf package/network/services/zerotier
#git clone --depth=1 https://github.com/zerotier/ZeroTierOne.git package/network/services/zerotier
