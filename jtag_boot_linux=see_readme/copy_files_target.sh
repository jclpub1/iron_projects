#!/bin/bash
# ********************************************************
# UNCLASSIFIED
# Perspecta Labs 2020.
# ********************************************************
if [ "$#" -ne 1 ]; then
  echo "Usage:"
  echo "$0 /media/USER/SDCARD_MOUNT_ROOT/"
  echo "$0 root@IP_ADDRESS:/run/media/mmcblk0p1/"
else
  echo "Copying files to target $1"

  # Just in case we forgot as it is fast.
  ./package.sh

  #ssh-keygen -f ~/.ssh/known_hosts -R "$1"
  if [ -f ~/.ssh/id_rsa.pub ]; then
     cp  ~/.ssh/id_rsa.pub /tmp/authorized_keys
     #cp  ./authorized_keys /tmp/authorized_keys
  else
    echo "~/.ssh/id_rsa.pub does not exist.  You will need to enter a password to SSH into system"
    touch /tmp/authorized_keys
  fi
  #scp FF_U8_Rev1.sh /tmp/authorized_keys dropbear_rsa_host_key autostart.sh images/linux/image.ub images/linux/BOOT.BIN images/linux/boot.scr dt/ethenable.dtbo $1/
  #scp -r waveforms $1/
  #scp /tmp/authorized_keys autostart.sh images/linux/image.ub images/linux/BOOT.BIN images/linux/boot.scr  $1/
  scp copy_boot_to_qspi.sh dropbear_rsa_host_key /tmp/authorized_keys autostart.sh images/linux/image.ub images/linux/BOOT.BIN boot.scr.uimg show_temp.out $1/
fi
