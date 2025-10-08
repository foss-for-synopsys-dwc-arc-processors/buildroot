#!/bin/sh
# Minimal post-build fixups for nSIM rootfs
set -eu

TARGET_DIR="${TARGET_DIR:-$1}"
if [ -z "${TARGET_DIR}" ] || [ ! -d "${TARGET_DIR}" ]; then
    echo "ERROR: TARGET_DIR not set or invalid" >&2
    exit 1
fi

# Ensure init script to auto-run CoreMark is executable
if [ -f "${TARGET_DIR}/etc/init.d/S99coremark" ]; then
    chmod 0755 "${TARGET_DIR}/etc/init.d/S99coremark"
fi

exit 0
