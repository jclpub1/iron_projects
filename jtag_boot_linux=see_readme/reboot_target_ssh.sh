#!/bin/bash
# ********************************************************
# UNCLASSIFIED
# Perspecta Labs 2020.
# ********************************************************

if [ "$#" -ne 1 ]; then
  echo "Usage:"
  echo "$0 IP_ADDRESS"
else
  ssh root@$1 /sbin/shutdown -r now
fi
