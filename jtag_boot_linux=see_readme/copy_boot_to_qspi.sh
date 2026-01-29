# Erase the Flash that holds BOOT.BIN
echo "Erasing Flash"
/usr/sbin/mtd_debug erase /dev/mtd0 0 0x2300000
# Show the head of the flash
echo "Flash Erased"
hexdump -Cv /dev/mtd0 | head
# Write the flash
echo "Writing Flash"
/usr/sbin/mtd_debug write /dev/mtd0 0 $(wc -c /media/sd-mmcblk0p1/BOOT.BIN)
# Show the head of the flash
echo "Flash Written"
hexdump -Cv /dev/mtd0 | head
