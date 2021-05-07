#############################################################
#
# MultiBench
#
#############################################################
EEMBC_MULTIBENCH_VERSION = master
EEMBC_MULTIBENCH_SITE = git@gitsnps.internal.synopsys.com:arc_oss/eembc_multibench.git
EEMBC_MULTIBENCH_SITE_METHOD = git
define EEMBC_MULTIBENCH_BUILD_CMDS
    $(MAKE) LD="$(TARGET_CC)" AR="$(TARGET_AR)" CC="$(TARGET_CC)" -C $(@D) build TARGET=linux TOOLCHAIN=arc64_linux TPREF=arc64-buildroot-linux-gnu-
endef
define EEMBC_MULTIBENCH_INSTALL_TARGET_CMDS
	-mkdir -m 0755 $(TARGET_DIR)/multibench/
	cp -r $(@D)/builds/linux/bin/ $(TARGET_DIR)/multibench/
	cp -r $(@D)/builds/linux/data/ $(TARGET_DIR)/multibench/
	cp $(@D)/{multibench.sh,mbench.sh,soak.sh} $(TARGET_DIR)/multibench/bin/
endef
$(eval $(generic-package))
