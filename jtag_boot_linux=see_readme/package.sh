# ********************************************************
# UNCLASSIFIED
# Perspecta Labs 2020.
# ********************************************************
petalinux-package --force --boot --fsbl images/linux/zynqmp_fsbl.elf --fpga images/linux/system.bit --pmufw images/linux/pmufw.elf --u-boot images/linux/u-boot.elf
#petalinux-package --force --boot --fsbl images/linux/zynqmp_fsbl.elf --fpga images/linux/system.bit --pmufw images/linux/pmufw.elf --u-boot u-boot.backup/u-boot.elf 

