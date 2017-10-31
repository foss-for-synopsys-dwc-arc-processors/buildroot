import os, getopt, sys, zlib
#we can use binascii instead of zlib

def usage(exit_code):
    print("usage:")
    print(sys.argv[0] + " --arc-id 0x52 --image u-boot.bin --elf u-boot")
    sys.exit(exit_code)

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:],
            "ha:i:l:e:", ["help", "arc-id=", "image=", "elf=", "env="])
    except getopt.GetoptError as err:
        print(err)
        usage(2)

    # default filenames
    uboot_bin_filename  = "u-boot.bin"
    uboot_elf_filename  = "u-boot"
    headerised_filename = "u-boot.head"
    uboot_default_env   = "u-boot-env.txt"
    uboot_patched_env   = "u-boot-p-env.txt"

    # initial header values
    arc_id          = 0x52
    uboot_img_size  = 0x0497fc
    check_sum       = 0x61
    image_copy_adr  = 0x81000000
    magic1          = 0xdeadbeafaf # big endian byte order
    jump_address    = 0x81000000
    flash_address   = 0x0
    flash_type      = 0x0          # 0 - SPI flash, 1 - NOR flash
    magic2          = [            # big endian byte order
    0x20202a2020202020202020202a20202020207c5c2e20202020202e2f7c20202020207c2d,
    0x2e5c2020202f2e2d7c20202020205c2020602d2d2d6020202f20202020202f205f202020,
    0x205f20205c20202020207c205f60712070205f207c2020202020272e5f3d2f205c3d5f2e,
    0x272020202020202020605c202f60202020202020202020202020206f2020202020202020]

    for opt, arg in opts:
        if opt in ('-h', "--help"):   usage(0)
        if opt in ('-a', "--arc-id"): arc_id = int(arg, 16)
        if opt in ('-i', "--image"):  uboot_bin_filename = arg
        if opt in ('-l', "--elf"):    uboot_elf_filename = arg
        if opt in ('-e', "--env"):    uboot_default_env  = arg

    # verify args:
    if arc_id not in [0x52, 0x53]:
        print("unknown ARC ID: " + hex(arc_id))
        sys.exit(2)

    if not os.path.isfile(uboot_bin_filename):
        print("uboot bin file not exists: " + uboot_bin_filename)
        sys.exit(2)

    if not os.path.isfile(uboot_default_env):
        print("uboot defaul environment file not exists: " + uboot_default_env)
        sys.exit(2)

    uboot_img_size = os.path.getsize(uboot_bin_filename)

    # Calculate u-boot image check_sum: it is sum of all u-boot binary bytes
    with open(uboot_bin_filename, "rb") as file:
        ba = bytearray(file.read())
    check_sum = sum(ba) & 0xFF

    # write header to file
    with open(headerised_filename, "wb") as file:
        file.write(arc_id.to_bytes(2, byteorder='little'))
        file.write(uboot_img_size.to_bytes(4, byteorder='little'))
        file.write(check_sum.to_bytes(1, byteorder='little'))
        file.write(image_copy_adr.to_bytes(4, byteorder='little'))
        file.write(magic1.to_bytes(5, byteorder='big'))
        file.write(jump_address.to_bytes(4, byteorder='little'))
        for i in range(12): file.write(0xFF.to_bytes(1, byteorder='little'))
        for byte in magic2: file.write(byte.to_bytes(36, byteorder='big'))
        for i in range(208 - len(magic2) * 36):
            file.write(0xFF.to_bytes(1, byteorder='little'))
        file.write(flash_address.to_bytes(4, byteorder='little'))
        for i in range(11): file.write(0xFF.to_bytes(1, byteorder='little'))
        file.write(flash_type.to_bytes(1, byteorder='little'))

    # append u-boot image to header
    with open(headerised_filename, "ab") as fo:
        with open(uboot_bin_filename,'rb') as fi:
            fo.write(fi.read())

    # calc u-boot headerised image CRC32 (will be used by uboot update
    # command for check)
    headerised_image_crc = ""
    with open(headerised_filename, "rb") as fi:
        headerised_image_crc = hex(zlib.crc32(fi.read()) & 0xffffffff)
    print("image CRC32 = " + headerised_image_crc)

    load_addr = 0x81000000
    load_size = os.path.getsize(headerised_filename)

    print("crc32 " + hex(load_addr) + " " + hex (load_size))

    # make errase size to be allighned by 64K
    if load_size & 0xFFFF == 0:
        errase_size = load_size
    else:
        errase_size = load_size - (load_size & 0xFFFF) + 0x10000

    # u-bood CMD to load u-bood with header to SPI flash
    sf_load_image_cmd = \
        "fatload mmc 0:1 " + hex(load_addr) + " " + headerised_filename + " && " + \
        "sf probe 0:0 && " + \
        "sf protect unlock 0x0 " + hex(errase_size) + " && " + \
        "sf erase 0x0 " + hex(errase_size) + " && " + \
        "sf write " + hex(load_addr) + " 0x0 " + hex(errase_size) + " && " + \
        "sf protect lock 0x0 " + hex(errase_size)

    # address to load u-boot ELF file. ELF will unpack to BIN to address
    # specified in ELF header (probably 0x81000000)
    elf_addr = 0x85000000
    elf_load_cmd = \
        "fatload mmc 0:1 " + hex(elf_addr) + " " + uboot_elf_filename + "; " + \
        "bootelf -s " + hex(elf_addr)

    update_uboot_cmd = "update_uboot=" + \
        "setenv bootcmd__ $bootcmd; " + \
        "setenv bootdelay__ $bootdelay; " + \
        "setenv bootdelay 0; " + \
        "setenv update_on_boot__ TRUE; " + \
        "setenv bootcmd run ufmc__; " + \
        "saveenv; " + elf_load_cmd
#    print(update_uboot_cmd)

    ufmc_cmd = "ufmc__=" + \
        "test $update_on_boot__ = \"TRUE\" && " + \
        "setenv bootcmd $bootcmd__ && " + \
        "setenv bootdelay $bootdelay__ && " + \
        "setenv bootdelay__ && " + \
        "setenv update_on_boot__ && " + \
        "saveenv && " + \
        sf_load_image_cmd + " && echo \"u-boot update: OK\""
#    print(ufmc_cmd)

    upd_comands = ("\n" + update_uboot_cmd + "\n" + ufmc_cmd).encode('ascii')

    # append default environment with update commands
    with open(uboot_default_env, "rb") as fi:
        with open(uboot_patched_env, 'wb') as fo:
            fo.write(fi.read())
            fo.write(upd_comands)


if __name__ == "__main__":
    main()
