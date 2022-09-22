include $(TOPDIR)/rules.mk

PKG_NAME:=ipcam
PKG_VERSION:=0.1
PKG_RELEASE:=1
# PKG_SOURCE:=
# UNPACK_CMD=#cp -R $(PKG_SOURCE)/* $(1)
# PKG_INSTALL:=1
# PKG_BUILD_PARALLEL:=1
PKG_MAINTAINER:=Vadim Radovel <vadim@radovel.ru>

include $(INCLUDE_DIR)/package.mk

define Package/ipcam
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=Metapackage for building image for IP Cam system with motion
  DEPENDS:=+kmod-wireguard +wireguard-tools +tcpdump-mini \
      +kmod-usb-storage +kmod-usb2 +e2fsprogs +block-mount \
      +curl +libcurl @+LIBCURL_ZLIB @+LIBCURL_OPENSSL \
      +libopenssl \
      +libffmpeg-full +libx264 @+BUILD_NLS @+BUILD_PATENTED \
      +motion
  MENU:=1
endef

define Package/ipcam/config
	source "$(SOURCE)/Config.in"
endef

Build/Configure=
Build/Compile=


define ipcam_subst_var
	sed -i 's#$(1)#$$(shell echo $$(CONFIG_$(1)))#g' $(2)

endef

define ipcam_subst_all
$(call ipcam_subst_var,IPCAM_TELEGRAM_TOKEN,$(1))
$(call ipcam_subst_var,IPCAM_TELEGRAM_CHAT_ID,$(1))
$(call ipcam_subst_var,IPCAM_CAMERA_NAME,$(1))
$(call ipcam_subst_var,IPCAM_CAMERA_ID,$(1))
$(call ipcam_subst_var,IPCAM_CAMERA_URL,$(1))
$(call ipcam_subst_var,IPCAM_TARGET_DIR_ALL,$(1))
$(call ipcam_subst_var,IPCAM_STORAGE_DEVICE,$(1))
$(call ipcam_subst_var,IPCAM_WG_PRIV_KEY,$(1))
$(call ipcam_subst_var,IPCAM_WG_SRV_PUB_KEY,$(1))
$(call ipcam_subst_var,IPCAM_WG_SRV_PUB_HOST,$(1))
$(call ipcam_subst_var,IPCAM_WG_SRV_PUB_PORT,$(1))
$(call ipcam_subst_var,IPCAM_WG_PORT,$(1))
$(call ipcam_subst_var,IPCAM_WG_IP,$(1))
$(call ipcam_subst_var,IPCAM_WG_PREFIX,$(1))
$(call ipcam_subst_var,IPCAM_WG_LAN_IPADDR,$(1))
$(call ipcam_subst_var,IPCAM_CAM1_MAC_ADDR,$(1))
$(call ipcam_subst_var,IPCAM_CAM1_IP,$(1))
endef


define Package/ipcam/postrm
#!/bin/sh

rm -vf $(1)/etc/config/ipcam
rm -vf $(1)/etc/motion-all.conf
rm -vf $(1)/etc/uci-defaults/999_ipcam
endef

define Package/ipcam/install
	# echo "metapackage, do nothing"
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) files/ipcam.config  $(1)/etc/config/ipcam
$(call ipcam_subst_all,$(1)/etc/config/ipcam)

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/send_notify_text.sh $(1)/usr/bin/send_notify_text.sh 
	$(INSTALL_BIN) files/send_notify_video.sh $(1)/usr/bin/send_notify_video.sh
	$(INSTALL_BIN) files/stats.sh $(1)/usr/bin/stats.sh
	$(INSTALL_BIN) files/storageclean.sh $(1)/usr/bin/storageclean.sh

	$(INSTALL_DATA) files/motion-all.conf $(1)/etc/motion-all.conf
$(call ipcam_subst_all,$(1)/etc/motion-all.conf)
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/motion-all.initd $(1)/etc/init.d/motion-all

	$(INSTALL_DIR) $(1)/storage
	$(INSTALL_DIR) $(1)/etc/uci-defaults/
	$(INSTALL_BIN) files/uci_defaults $(1)/etc/uci-defaults/999_ipcam
$(call ipcam_subst_all,$(1)/etc/uci-defaults/999_ipcam)
endef

$(eval $(call BuildPackage,ipcam))
