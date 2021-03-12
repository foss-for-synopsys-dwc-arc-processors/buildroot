################################################################################
#
# libffi
#
################################################################################

LIBFFI_VERSION = arc64
LIBFFI_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,libffi,$(LIBFFI_VERSION))
LIBFFI_SOURCE = libffi-$(LIBFFI_VERSION).tar.gz
BR_NO_CHECK_HASH_FOR += $(LIBFFI_SOURCE)
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES
LIBFFI_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
