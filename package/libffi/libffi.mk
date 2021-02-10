################################################################################
#
# libffi
#
################################################################################

ifeq ($(BR2_arc),)
LIBFFI_VERSION = 3.4.2
LIBFFI_SITE = \
	https://github.com/libffi/libffi/releases/download/v$(LIBFFI_VERSION)
else
LIBFFI_VERSION = arc64
LIBFFI_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,libffi,$(LIBFFI_VERSION))
LIBFFI_SOURCE = libffi-$(LIBFFI_VERSION).tar.gz
BR_NO_CHECK_HASH_FOR += $(LIBFFI_SOURCE)
endif
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES
# We're patching Makefile.am
LIBFFI_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
