#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.2.200）
# sed -i 's/192.168.1.1/192.168.2.200/g' package/base-files/files/bin/config_generate
# 修改默认主机名(OpenWrt->LEDE)
sed -i 's/OpenWrt/LEDE/g' package/base-files/files/bin/config_generate

# 网络配置信息，将从 zzz-default-settings 文件的第2行开始添加
# 设置lan
sed -i "2i # network config" package/lean/default-settings/files/zzz-default-settings
sed -i "3i uci set network.lan=interface" package/lean/default-settings/files/zzz-default-settings
sed -i "4i uci set network.lan.ipaddr='192.168.3.1'" package/lean/default-settings/files/zzz-default-settings
sed -i "5i uci set network.lan.proto='static'" package/lean/default-settings/files/zzz-default-settings
sed -i "6i uci set network.lan.type='bridge'" package/lean/default-settings/files/zzz-default-settings
sed -i "7i uci set network.lan.ifname='eth0'" package/lean/default-settings/files/zzz-default-settings
sed -i "8i uci set network.lan.netmask='255.255.255.0'" package/lean/default-settings/files/zzz-default-settings

# 关闭lan口dhcp
sed -i "9i uci set dhcp.lan.ignore='1'" package/lean/default-settings/files/zzz-default-settings
sed -i "10i uci commit dhcp\n" package/lean/default-settings/files/zzz-default-settings

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

