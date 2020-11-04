include $(TOPDIR)/rules.mk

PKG_NAME:=repairer
PKG_VERSION:=0.1
PKG_RELEASE:=4
# PKG_SOURCE:=
# UNPACK_CMD=#cp -R $(PKG_SOURCE)/* $(1)
# PKG_INSTALL:=1
# PKG_BUILD_PARALLEL:=1
PKG_MAINTAINER:=Vadim Radovel <vadim@radovel.ru>

include $(INCLUDE_DIR)/package.mk

define Package/repairer
	SECTION:=admin
	CATEGORY:=Administration
	TITLE:=Internet repairer script (restarts network if ping fails)
	DEPENDS:=+lua +luasocket
endef

Build/Configure=
Build/Compile=

define Package/repairer/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/repairer.lua $(1)/usr/bin/repairer.lua
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/repairer $(1)/etc/init.d/repairer
endef

$(eval $(call BuildPackage,repairer))
