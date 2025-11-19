# RISC-V Linux with AIA on QEMU - Quick Start

## Build Buildroot

```bash
git clone -b nsim-virtio-boot-support \
  https://github.com/foss-for-synopsys-dwc-arc-processors/buildroot.git

cd buildroot
make nsim_riscv64_defconfig
make -j$(nproc)
```

**Build time**: ~15 minutes

## Run on QEMU

### Single-Core
```bash
qemu-system-riscv64 \
  -M virt,aia=aplic-imsic \
  -m 1G \
  -nographic \
  -kernel output/images/Image \
  -append "earlycon=sbi console=ttyS0 root=/dev/vda rw" \
  -drive file=output/images/rootfs.ext2,format=raw,if=none,id=hd0 \
  -device virtio-blk-device,drive=hd0
```

### Dual-Core
```bash
qemu-system-riscv64 \
  -M virt,aia=aplic-imsic \
  -smp 2 \
  -m 1G \
  -nographic \
  -kernel output/images/Image \
  -append "earlycon=sbi console=ttyS0 root=/dev/vda rw" \
  -drive file=output/images/rootfs.ext2,format=raw,if=none,id=hd0 \
  -device virtio-blk-device,drive=hd0
```

### Quad-Core
```bash
qemu-system-riscv64 \
  -M virt,aia=aplic-imsic \
  -smp 4 \
  -m 1G \
  -nographic \
  -kernel output/images/Image \
  -append "earlycon=sbi console=ttyS0 root=/dev/vda rw" \
  -drive file=output/images/rootfs.ext2,format=raw,if=none,id=hd0 \
  -device virtio-blk-device,drive=hd0
```

**Exit QEMU**: `Ctrl-A` then `X`

## Login

- **Username**: `root`
- **Password**: (press Enter)

## Verify AIA

```bash
# Check AIA is enabled
dmesg | grep "aia-imsic"
# Expected: Platform IPI Device       : aia-imsic

# Check APLIC and IMSIC
dmesg | grep -i "aplic\|imsic"
# Expected:
#   riscv-imsic: providing IPIs using interrupt 1
#   riscv-aplic: 96 interrupts forwarded to MSI base 0x28000000

# Check number of CPUs
cat /proc/cpuinfo | grep processor

# Check interrupt controller
cat /proc/interrupts | head -15
# Expected: APLIC-MSI-d000000.interrupt-controller
```

## What You'll See

```
OpenSBI v1.5.1
Platform IPI Device       : aia-imsic
Platform HART Count       : 4

riscv-intc: 64 local interrupts mapped using AIA
riscv-imsic: total 1016 interrupts available
riscv-aplic: 96 interrupts forwarded to MSI base 0x28000000
smp: Brought up 1 node, 4 CPUs
```

## Prerequisites

- QEMU 10.0+ with RISC-V support
- Build tools: gcc, make, bc, bison, flex

## Features

✅ APLIC (Advanced PLIC) in MSI mode  
✅ IMSIC (Incoming MSI Controller)  
✅ Multi-core SMP (1, 2, or 4 cores)  
✅ IPIs via IMSIC  
✅ Interrupt distribution across CPUs

---

**Maintained by**: Synopsys ARC Processor Group  
**Contact**: afonsoo@synopsys.com
