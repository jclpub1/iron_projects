#!/bin/bash
# ********************************************************
# UNCLASSIFIED
# Perspecta Labs 2020.
# ********************************************************

if [ "$#" -ne 1 ]; then
  echo "Usage:"
  echo "$0 IP_ADDRESS"
else
  ./copy_files_target.sh root@$1:/media/sd-mmcblk0p1/

  read -p "Attempt to write QSPI FLASH (ONLY NEEDED IF FPGA BITFILE CHANGED) on target [Y/N]:" -n 1 -r
  echo ""    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "This will take a few mins."
    ssh root@$1 /media/sd-mmcblk0p1/copy_boot_to_qspi.sh
  fi
fi
