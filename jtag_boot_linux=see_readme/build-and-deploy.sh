./hw_config.sh
petalinux-build 
./copy_files_ssh.sh "$1" 
./reboot_target_ssh.sh "$1"
