#!/bin/sh
# ********************************************************
# UNCLASSIFIED
# Perspecta Labs 2020.
# ********************************************************
#consistent RSA ID
cp /media/sd-mmcblk0p1/dropbear_rsa_host_key /etc/dropbear/

# Don't require SSH Password
mkdir -p /home/root/.ssh
cp /media/sd-mmcblk0p1/authorized_keys /home/root/.ssh/
/etc/init.d/dropbear restart

# FIXED IP
ifconfig -a | grep eth0
RESULT=$?
if [ $RESULT -eq 0 ]; then
echo eth0 exists
# Uncomment ff you want a fixed IP.
#ifconfig eth0 192.168.0.10
fi


echo "Done"
