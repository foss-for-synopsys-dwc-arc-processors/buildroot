################################################################################
#
# ltp-testsuite
#
################################################################################

ifeq ($(BR2_arc),y)
LTP_TESTSUITE_VERSION = master
LTP_TESTSUITE_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,ltp,$(LTP_TESTSUITE_VERSION))
LTP_TESTSUITE_SOURCE = ltp-$(LTP_TESTSUITE_VERSION).tar.gz
else
LTP_TESTSUITE_VERSION = 20140115
LTP_TESTSUITE_SOURCE = ltp-full-$(LTP_TESTSUITE_VERSION).tar.xz
LTP_TESTSUITE_SITE = http://downloads.sourceforge.net/project/ltp/LTP%20Source/ltp-$(LTP_TESTSUITE_VERSION)
endif

LTP_TESTSUITE_LICENSE = GPLv2 GPLv2+
LTP_TESTSUITE_LICENSE_FILES = COPYING

# Needs libcap with file attrs which needs attr, so both required
ifeq ($(BR2_PACKAGE_LIBCAP)$(BR2_PACKAGE_ATTR),yy)
LTP_TESTSUITE_DEPENDENCIES += libcap
else
LTP_TESTSUITE_CONF_ENV += ac_cv_lib_cap_cap_compare=no
endif

ifeq ($(BR2_arc),y)
LTP_TESTSUITE_CONF_OPTS += --enable-arc-support

define LTP_TESTSUITE_PRECONFIGURE
	make -C $(@D) autotools
endef

LTP_TESTSUITE_PRE_CONFIGURE_HOOKS += LTP_TESTSUITE_PRECONFIGURE
endif

# ltp-testsuite uses <fts.h>, which isn't compatible with largefile
# support.
LTP_TESTSUITE_CONF_ENV += \
	CFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))" \
	CPPFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))"

$(eval $(autotools-package))
