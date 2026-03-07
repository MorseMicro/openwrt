include $(TOPDIR)/rules.mk

PKG_NAME:=mm81x-firmware
PKG_VERSION:=1.0
PKG_RELEASE=1

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=

PKG_MAINTAINER:=Morse Micro
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/mm81x-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=MM8108 Chip Firmware
  FILES:=\
    $(PKG_BUILD_DIR)/mm81x.ko
endef

define Build/Compile

endef

define Package/mm81x-firmware/install
	$(INSTALL_DIR) $(1)/etc/boot-defaults
	$(INSTALL_BIN) ./files/etc/boot-defaults/99-set-default-driver $(1)/etc/boot-defaults/

	$(INSTALL_DIR) $(1)/lib/firmware/morsemicro
	$(INSTALL_BIN) ./files/lib/firmware/morsemicro/* $(1)/lib/firmware/morsemicro/

	ln -sf bcf_mf15457.bin \
		$(1)/lib/firmware/morsemicro/bcf_boardtype_0804.bin

	ln -sf bcf_mf15457.bin \
		$(1)/lib/firmware/morsemicro/bcf_boardtype_0807.bin

	ln -sf bcf_mf15457.bin \
		$(1)/lib/firmware/morsemicro/bcf_boardtype_0a02.bin

	ln -sf bcf_failsafe.bin \
		$(1)/lib/firmware/morsemicro/bcf_default.bin
endef
$(eval $(call BuildPackage,mm81x-firmware))
