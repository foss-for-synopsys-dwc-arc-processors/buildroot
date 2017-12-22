#!/bin/bash

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
rm -rf "${GENIMAGE_TMP}"

mv ${BINARIES_DIR}/uboot-env.bin ${BINARIES_DIR}/uboot.env

genimage                           \
        --rootpath "${TARGET_DIR}"     \
        --tmppath "${GENIMAGE_TMP}"    \
        --inputpath "${BINARIES_DIR}"  \
        --outputpath "${BINARIES_DIR}" \
        --config "${GENIMAGE_CFG}"
gzip < ${BINARIES_DIR}/sdcard.img > ${BINARIES_DIR}/sdcard.img.gz
exit $?
