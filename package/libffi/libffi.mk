################################################################################
#
# libffi
#
################################################################################

LIBFFI_VERSION = 73acfaf8cfd445e9d44b40de8a07d06d8be71e1f
LIBFFI_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,libffi,$(LIBFFI_VERSION))
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES
LIBFFI_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
