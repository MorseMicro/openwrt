include $(TOPDIR)/rules.mk

PKG_NAME:=mm81x
PKG_VERSION:=1.0.1
PKG_RELEASE=1

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=

PKG_SOURCE_URL:=ssh://git@bitbucket.org/morsemicro/morse-upstream-driver.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=$(PKG_VERSION)

PKG_MAINTAINER:=Morse Micro
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

DTC=$(wildcard $(LINUX_DIR)/scripts/dtc/dtc)

define KernelPackage/mm81x
  SUBMENU:=Wireless Drivers
  TITLE:=Morse Micro WIFI HaLow driver
  DEPENDS:= +kmod-mmc +kmod-mac80211 +kmod-trelay +kmod-lib-crc7 +morse-bundle +MORSE_USB:kmod-usb-core +netifd +@DRIVER_11AH_SUPPORT
  FILES:=\
    $(PKG_BUILD_DIR)/mm81x.ko
  PROVIDES:=kmod-mm81x
  AUTOLOAD:=$(call AutoProbe,mm81x)
endef

MORSE_MAKEDEFS += CONFIG_MM81X_USB=y
MORSE_MAKEDEFS += CONFIG_MM81X_SDIO=y

NOSTDINC_FLAGS = \
	-I$(PKG_BUILD_DIR) \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-include backport/autoconf.h \
	-include backport/backport.h

include $(INCLUDE_DIR)/kernel-defaults.mk

define Build/Compile
	$(MAKE) $(MORSE_MAKEDEFS) $(PKG_JOBS) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)" \
		EXTRA_CFLAGS="-Wno-error" \
		NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
		modules
endef

define KernelPackage/mm81x/install
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
$(eval $(call KernelPackage,mm81x))
