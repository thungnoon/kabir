#!/bin/bash
# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add openwrt-packages
git clone --depth=1 https://github.com/xuanranran/openwrt-package openwrt-package
git clone --depth=1 https://github.com/xuanranran/rely openwrt-rely
git clone --depth=1 https://github.com/immortalwrt/wwan-packages wwan-packages
git clone --depth=1 https://github.com/sirpdboy/luci-app-poweroffdevice luci-app-poweroffdevice
chmod 755 openwrt-package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh
popd

# Update OpenClash Panel
pushd customfeeds/lovepackages/luci-app-openclash/root/usr/share/openclash/ui/
rm -rf zashboard metacubexd
git clone --depth 1 -b gh-pages https://github.com/metacubex/metacubexd metacubexd
curl -LJO https://github.com/Zephyruso/zashboard/releases/latest/download/dist-cdn-fonts.zip
unzip -qq dist-cdn-fonts.zip
mv dist zashboard
rm -rf dist-cdn-fonts.zip
# git clone --depth 1 -b gh-pages https://github.com/Zephyruso/zashboard zashboard
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate
sed -i "s/ImmortalWrt/OpenWrt/g" package/base-files/files/bin/config_generate

# 修改开源站地址
# sed -i '/@OPENWRT/a\\t\t"https://source.cooluc.com",' scripts/projectsmirrors.json
sed -i 's/mirror.iscas.ac.cn/mirrors.ustc.edu.cn/g' scripts/projectsmirrors.json

sed -i 's/services/network/g' customfeeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json
sed -i 's/services/network/g' customfeeds/luci/applications/luci-app-frpc/root/usr/share/luci/menu.d/luci-app-frpc.json

# other
rm -rf target/linux/x86/base-files/etc/board.d/02_network
rm -rf package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/02_network target/linux/x86/base-files/etc/board.d/02_network
