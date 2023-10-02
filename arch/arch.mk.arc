ifeq ($(BR2_arc),y)

# -matomic is always required when the ARC core has the atomic extensions
ifeq ($(BR2_ARC_ATOMIC_EXT),y)
ifeq ($(BR2_arc64)$(BR2_arc32),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -matomic=1
else
ARCH_TOOLCHAIN_WRAPPER_OPTS += -matomic
endif
endif

# Explicitly set LD's "max-page-size" instead of relying on some defaults
ifeq ($(BR2_ARC_PAGE_SIZE_4K),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -Wl,-z,max-page-size=4096
TARGET_CFLAGS += -Wl,-z,max-page-size=4096
else ifeq ($(BR2_ARC_PAGE_SIZE_8K),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -Wl,-z,max-page-size=8192
TARGET_CFLAGS += -Wl,-z,max-page-size=8192
else ifeq ($(BR2_ARC_PAGE_SIZE_16K),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -Wl,-z,max-page-size=16384
TARGET_CFLAGS += -Wl,-z,max-page-size=16384
endif

endif
