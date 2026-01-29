# RFSoC Doppler 5g

## Getting started

Backup of the petalinux RFSoC code for Velocite5g. This repository is not self contained. It is built using Petalinux 2020.2

## Configuring Petalinux bsp
```sh
source $PETALINUX_TOOLS/settings.sh
cd $SW_LOCATION/$BOARD_BSP

# You may need to do the following to avoid strange out of space errors when there is in fact space on the drive.
# 100000 is arbitrary.  default is 8192
sudo sysctl -n -w fs.inotify.max_user_watches=100000

## Useful commands.  Not regularly required.
# Configure the build system
petalinux-configure

# Configure u-boot (SHOULD NOT BE NEEDED)
petalinux-configure -c u-boot

# Configure installed packages
petalinux-configure -c rootfs

# Configure installed kernel
# Note that in Ubuntu 2020.2 this seems to hang, but has actually just opened up a "GUI" in another terminal tab.
petalinux-configure -c kernel

```


## Build the software

```sh
source $PETALINUX_TOOLS/settings.sh
cd $SW_LOCATION/$BOARD_BSP

# ANY TIME YOU PERFORM A NEW GIT PULL
# Configure the HW
./hw-config.sh


# Clean the Build
# ONLY DO THIS IF YOU ARE RUNNING INTO BUILD ISSUES OR A NEW BUILD.  REBUILDING AFTER THIS TAKES A LONNNNNGGGG TIME
petalinux-build -x mrproper

#Build
#You should not need to perform a clean unless you make a major change to the hardware
# i.e., small changes that do not reconfigure the ZYNQMP Peripherals should require only:
./hw-config.sh
petalinux-build

# Code changes require only
petalinux-build
```

## Deploy the software

```sh
###  Update target Software via writing to sdcard
#Insert the SDCARD into build machine
./copy_files_target.sh /media/XXXXX/YYYYYYYY/
umount /media/XXXXX/YYYYYYYY/

###  ALTERNATIVELY Update via ssh connection to target
./copy_files_target.sh root@IP_ADDRESS:/run/media/mmcblk0p1/
# or (shortcut)
./copy_files_ssh.sh IP_ADDRESS

# Either WAIT a LONG time, or shutdown the target cleanly via the terminal or ssh
# Failing to do so by immediately power cycling the target can result in boot file corruption
./reboot_target_ssh.sh IP_ADDRESS

###  Update Application via SSH
#NOTE!!!!:  Make sure the app is not running on the target first or this will fail.
./copy_app_target.sh IP_ADDRESS


```


## RFSOC Networking.
There are two options:
1. By default the board will attempt to DHCP and address.  The address can be learned via the serial Console.

2. Copy autostart.sh to the root directory of the sdcard.  In this file, you can configure a fixed IP address.  See $SW_LOCATION/rfsoc_petalinux_bsp/autostart.sh for an example.


## RFSoC JTAG Booting.
# This is a procedure created by Bill Johnson that will load all the necessary images to the DDR to runt the fsbl, u-boot and boot into the Linux kernel.
1. Run the commands to build Petalinux. Step d makes BOOT.BIN.
a) RFSoC-doppler-5g$ source path_to_petalinux_install/petalinux/settings.sh
b) RFSoC-doppler-5g$ petalinux-config --get-hw-description p6001_064.xsa
c) RFSoC-doppler-5g$ petalinux-build
d) petalinux-package --force --boot --fsbl images/linux/zynqmp_fsbl.elf --fpga images/linux/system.bit --pmufw images/linux/pmufw.elf --u-boot images/linux/u-boot.elf

2. Place the RFSoC in the development chassis with SW2-3 ON to enable RTM JTAG, and SW2-7 ON, SW2-8 ON, SW2-9 ON, SW2-10 ON to set the PS for JTAG boot only.

3. The computer used to manage the RFSoC JTAG connection should have Vivado Lab Solutions installed.  The tools installed on machin triolo are located at "Vivado_Lab/Xilinx_Vivado_Lab_Lin_2022.1_0420_0327.tar.gz". 

4. Copy the files generated in step 1 to the JTAG management computer keeping the images/linux/ path names.  The files required are:
atriolo@elis:~/kbocan/xilinx_images/20230912$ ls -la images/linux/
total 1686528
drwxr-xr-x 3 atriolo atriolo      4096 Sep 12 11:47 .
drwxr-xr-x 3 atriolo atriolo      4096 Sep 12 11:45 ..
-rw-r--r-- 1 atriolo atriolo     51120 Sep 12 11:47 bl31.bin
-rw-r--r-- 1 atriolo atriolo    155448 Sep 12 11:47 bl31.elf
-rw-r--r-- 1 atriolo atriolo  35886620 Sep 12 11:45 BOOT.BIN
-rw-r--r-- 1 atriolo atriolo      1636 Sep 12 11:45 boot.scr
-rw-r--r-- 1 atriolo atriolo 293308928 Sep 12 11:47 Image
-rw-r--r-- 1 atriolo atriolo  99822368 Sep 12 11:45 image.ub
-rw-r--r-- 1 atriolo atriolo    132288 Sep 12 11:45 pmufw.elf
drwxr-xr-x 2 atriolo atriolo      4096 Sep 12 11:47 pxelinux.cfg
-rw-r--r-- 1 atriolo atriolo 275486208 Sep 12 11:45 rootfs.cpio
-rw-r--r-- 1 atriolo atriolo  91310092 Sep 12 11:45 rootfs.cpio.gz
-rw-r--r-- 1 atriolo atriolo  91310156 Sep 12 11:45 rootfs.cpio.gz.u-boot
-rw-r--r-- 1 atriolo atriolo 122683392 Sep 12 11:47 rootfs.jffs2
-rw-r--r-- 1 atriolo atriolo     17654 Sep 12 11:45 rootfs.manifest
-rw-r--r-- 1 atriolo atriolo  91588556 Sep 12 11:47 rootfs.tar.gz
-rw-r--r-- 1 atriolo atriolo  34437469 Sep 12 11:47 system.bit
-rw-r--r-- 1 atriolo atriolo     60369 Sep 12 11:47 system.dtb
-rw-r--r-- 1 atriolo atriolo   1094745 Sep 12 11:47 u-boot.bin
-rw-r--r-- 1 atriolo atriolo   1160864 Sep 12 11:45 u-boot.elf
-rw-r--r-- 1 atriolo atriolo 588149056 Sep 12 11:46 vmlinux
-rw-r--r-- 1 atriolo atriolo    123496 Sep 12 11:47 zynqmp_fsbl.elf
-rw-r--r-- 1 atriolo atriolo     67463 Sep 12 11:45 zynqmp-qemu-arm.dtb
-rw-r--r-- 1 atriolo atriolo     76843 Sep 12 11:45 zynqmp-qemu-multiarch-arm.dtb
-rw-r--r-- 1 atriolo atriolo     10215 Sep 12 11:47 zynqmp-qemu-multiarch-pmu.dtb

5. Open up a serial connection to the RFSoC with minicom or other suitable tool.

6. Inspect the first command in rfsoc_xsdb.sh, command "connect" is used to connect to JTAG.  The "connect" command should be used with "Xilinx Platform Cable II, Model DLC10" the "connect -url 10.109.130.208:3121" command should be used with "SmartLynq".  Power on the RFSoC and run rfsoc_xsdb.sh.  This script will address and configure the PMU, load the FPGA bit stream to *PS TAP*, reset the Cortex-A53. download the fsbl, download the Linus kernel image image.ub and download the Zynq boot loader u-boot.elf. 

7. Power on the RFSoC and run rfsoc_xsdb.sh.  Note, the SmarLynq JTAG operates much faster than the DLC10.  The SmartLynq will complete this procedure in several minutes where the DLC10 will take over an hour.

8. Monitor the serial terminal status and stop the boot process in the Zynq boot loader.

9. Run the Zynq "bootm 0x10000000" command to boot into Linux.

10. Once Linux is booted you can run copy_files_ssh.sh to copy the necessary images to the SD Card and QSPI FPGA Configuration Flash devices. 
 
 
## TFTP Linux Kernel Boot.
This procedure can be used to rapidly test new Linux kernel images provided the FPGA image hasn't changed.  A TFTP server must be accessible from the RFSoC subnet.  These instructions wer used to install TFTP on Ubuntu 18.04.
# Install TFTPD Server
1. Set up and configure a TFTP server on the RFSoC subnet, the TFTP server should have Petalinux installed.  URL https://linuxhint.com/install_tftp_server_ubuntu/ provides a good description of TFTP instalation and testing.

$ sudo apt install tftpd-hpa

2. Configure TFTP as follows.

atriolo@elis:/tftpboot$ sudo vi /etc/default/tftpd-hpa
# /etc/default/tftpd-hpa

TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/tftpboot"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure --create"

3. Create the /tftpboot folder with the permissions shown here.

$ mkdir /tftpboot
$ sudo chown tftp:tftp /tftpboot/

pl1@pl2:/tftpboot$ ls -la
drwxr-xr-x   2 tftp tftp       4096 Sep 11 16:28 tftpboot

4. Restart the tftpd service to apply the new configuration. 

$ sudo systemctl restart tftpd-hpa

5. Test that tftpd is running.

pl1@pl2:~/projects/velocite/software/RFSoC-doppler-5g$ sudo systemctl status tftpd-hpa
● tftpd-hpa.service - LSB: HPA's tftp server
   Loaded: loaded (/etc/init.d/tftpd-hpa; generated)
   Active: active (running) since Thu 2023-09-07 16:56:43 EDT; 19s ago
     Docs: man:systemd-sysv-generator(8)
    Tasks: 1 (limit: 4915)
   CGroup: /system.slice/tftpd-hpa.service
           └─24248 /usr/sbin/in.tftpd --listen --user tftp --address :69 --secure /var/lib/tftpboot

# Test the TFTPD Server with TFTP.  This can be done from the same or a different machine.
1. Install TFTP.
$ sudo apt install tftp-hpa

2. Start TFTP, enter verbose mode, TFTP a file to the TFTPD server, send a file from the TFTPD server to the TFTP client.
# On TFTP Client
a) $ touch toserver
b) $ tftp 10.109.130.154
c) tftp> verbose
Verbose mode is on.
d) tftp> put toserver
# On TFTP Server
e) $ ls /tftpboot
f) touch /tftpboot/fromserver
# On TFTP Client
g) tftp> get fromserver
h) tftp> q
$ ls
fromserver 

# Configure Petalinux to copy the images/linux files to /tftpboot.
1. Run  petalinux-config --get-hw-description p6001_064.xsa.  Select "Image Packing Configuration" enable "copy final images to tftpboot".
2. petalinux-build should now copy the output files to /tftpboot.  Note, this doesn't always work probably due to /tftpboot permissions.  If this is the case simply copy the files by hand.

$ cp ./images/linux/*.* /tftp

# Running the TFTP Linux image.
1. Restart the RFSoC and stop in the Zynq boot loader by pressing any key at the appropriate time.
2. Use the boottftp command to copy the TFTP Server Linux image to the RFSoC.
ZynqMP> tftpboot 10.109.130.154:image.ub
Using ethernet@ff0d0000 device
TFTP from server 10.109.130.194; our IP address is 10.109.130.190
Filename 'image.ub'.
Load address: 0x8000000
'Loading: #################################################################
'         #################################################################
'         #################################################################
'         #################################################################

3. You can also set the Zynq environment varibles if necessary.
ZynqMP> setenv serverip <TFTP SERVERIP>
ZynqMP> print serverip
ZynqMP> tftpboot image.ub


# Git Basics

## Saving your changes to gitlab
1. Make sure you are on the right branch
   git branch
   Make sure there is a star in front of your branch, e.g. myname-dev
   If star is on something else, do git checkout myname-dev
2. Check changes that were made
   git status -s
3. Add all the files that were modified
   git add <filename>
4. Commit changes and add a comment on what your are committing
   git commit -m "commit message"
5. Push changes    
   git push origin myname-dev

## Making a New Branch
1. Create a dev branch when we are ready to make changes
2. Include your name and a meaningful description in the name of the branch, e.g. yourname-dev-addXYZ
3. Make sure you don't have any pending changes (do a git status)
4. `git checkout master`
5. `git pull` (to get latest version of master)
6. `git checkout -b yourname-dev-name-of-change` (the new branch will be based off master)
7. `git push origin yourname-dev-name-of-change` (tells remote repo that a new branch exists)
8. `git branch -r` (verify your branch shows up on the remote repo)
9. ----make changes to code, commit like normal----
10. When ready, merge the branch into master
11. Delete branch after a successful merge
12. On computer that was on the branch that is now deleted, do the following to get back to master
13. `git checkout master`
14. `git remote prune origin` (this will remove branches that don't exist anymore)
15. `git pull` (will pull the latest master, which should have the recent changes merged into it)
