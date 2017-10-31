#!/bin/bash

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
rm -rf "${GENIMAGE_TMP}"

python3 ${BOARD_DIR}/headerise.py --arc-id 0x52 --image output/images/u-boot.bin --elf output/images/u-boot --env ${BOARD_DIR}/uboot.env.txt
mkenvimage -s 0x4000 -o output/images/uboot.env ./u-boot-p-env.txt
cp ./u-boot.head output/images
rm u-boot.head u-boot-p-env.txt
genimage                           \
        --rootpath "${TARGET_DIR}"     \
        --tmppath "${GENIMAGE_TMP}"    \
        --inputpath "${BINARIES_DIR}"  \
        --outputpath "${BINARIES_DIR}" \
        --config "${GENIMAGE_CFG}"

exit $?
