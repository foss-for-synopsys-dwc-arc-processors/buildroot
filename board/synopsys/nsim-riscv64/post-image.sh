#!/bin/bash
# Post-image script for nSIM RISC-V
# Creates separate ext2 boot filesystem for U-Boot VirtIO boot

BOOTFS_SIZE=32M
BOOTFS_IMAGE="${BINARIES_DIR}/bootfs.ext2"

# Create boot filesystem
echo "Creating ext2 boot filesystem..."
dd if=/dev/zero of="${BOOTFS_IMAGE}" bs=1M count=32 status=none
mkfs.ext2 -F "${BOOTFS_IMAGE}"

# Create temporary mount point
BOOT_MOUNT=$(mktemp -d)

# Mount boot filesystem
sudo mount -o loop "${BOOTFS_IMAGE}" "${BOOT_MOUNT}"

# Copy kernel as vmlinux for U-Boot
sudo cp "${BINARIES_DIR}/Image" "${BOOT_MOUNT}/vmlinux"

# Set proper permissions
sudo chmod 644 "${BOOT_MOUNT}/vmlinux"

# Unmount
sudo umount "${BOOT_MOUNT}"
rmdir "${BOOT_MOUNT}"

echo "nSIM post-image: Boot filesystem created at ${BOOTFS_IMAGE}"
echo "nSIM post-image: Kernel available as /vmlinux in bootfs.ext2"
echo "nSIM post-image: Root filesystem available as rootfs.ext2"