#
# Copyright (C) 2008-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=motion-ffmpeg
PKG_VERSION:=4.4.0
PKG_RELEASE:=2

PKG_SOURCE:=motion-release-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/Motion-Project/motion/tar.gz/release-$(PKG_VERSION)?
PKG_HASH:=3fb0d14fff8a8a143716223b5d2d55c0f52b11badf13a2e485b98bae3cf1b572
PKG_BUILD_DIR:=$(BUILD_DIR)/motion-release-$(PKG_VERSION)

PKG_MAINTAINER:=Vadim Radovel <vadim@radovel.ru>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYING
PKG_CPE_ID:=cpe:/a:lavrsen:motion

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/motion-ffmpeg
  SECTION:=multimedia
  CATEGORY:=Multimedia
  DEPENDS:=+libjpeg +libpthread +libmicrohttpd $(INTL_DEPENDS) +libffmpeg-full
  TITLE:=webcam motion sensing and logging (with ffmpeg support)
  URL:=https://motion-project.github.io/
endef

define Package/motion-ffmpeg/conffiles
/etc/config/motion
/etc/motion.conf
endef

CONFIGURE_ARGS += \
	--without-bktr \
	--without-webp \
	--without-mmal \
	--without-mariadb \
	--without-mysql \
	--without-pgsql \
	--without-sqlite3 \
	--without-optimizecpu

# CONFIGURE_ARGS+=--with-ffmpeg=$(STAGING_DIR)/usr
# CONFIGURE_ARGS+=--with-ffmpeg

define Package/motion-ffmpeg/install
	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/init.d
	$(INSTALL_CONF) ./files/motion.conf $(1)/etc/config/motion
	$(INSTALL_BIN) ./files/motion.init $(1)/etc/init.d/motion
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/etc/motion/motion-dist.conf $(1)/etc/motion.conf
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/motion $(1)/usr/bin/
endef

$(eval $(call BuildPackage,motion-ffmpeg))
