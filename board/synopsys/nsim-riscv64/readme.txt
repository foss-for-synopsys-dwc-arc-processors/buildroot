Synopsys nSIM RISC-V 64-bit Platform
=====================================

This configuration builds a Linux system compatible with the Synopsys nSIM
RISC-V simulator, specifically the ARC-V RPX-100 configuration.

Build instructions:
===================

1. Set up environment:
   export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

2. Configure buildroot:
   make nsim_riscv64_defconfig

3. Build the system:
   make -j$(nproc)

4. Output files:
   - output/images/Image (Linux kernel)
   - output/images/rootfs.ext2 (Root filesystem)

Key features:
=============
- RISC-V 64-bit with lp64d ABI
- Linux kernel 6.12.x with nSIM compatibility patches
- Disabled zicboz/zicbom extensions for simulator compatibility
- Systemd support with required kernel features
- ext2 root filesystem (100MB)

Integration with OpenSBI:
========================
The built kernel can be integrated with OpenSBI firmware:

cd opensbi
CROSS_COMPILE=riscv64-linux-gnu- make PLATFORM=nsim \
  FW_PAYLOAD_PATH=../buildroot/output/images/Image \
  FW_FDT_PATH=nsim_rpx100.dtb -j4

nSIM configuration:
==================
Use the provided nsim_rpx100.props file with:
nsimdrv -propsfile nsim_rpx100.props fw_payload.elf