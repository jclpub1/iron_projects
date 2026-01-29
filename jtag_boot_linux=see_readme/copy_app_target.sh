#!/bin/bash
# ********************************************************
# UNCLASSIFIED
# Perspecta Labs 2020.
# ********************************************************

if [ "$#" -ne 1 ]; then
  echo "Usage:"
  echo "$0 IP_ADDRESS"
else
petalinux-build -c velocite5g -x do_install
scp ./build/tmp/work/aarch64-xilinx-linux/velocite5g/1.0-r0/velocite5g root@$1:/usr/bin/

fi
