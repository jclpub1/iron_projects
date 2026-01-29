export XILINXD_LICENSE_FILE=2662@hwrad
#export LD_LIBRARY_PATH=/usr/local/flexlm/license_utilities_xilinx/lin_flexlm_v11.17.2.0/lnx64.o
#export LD_LIBRARY_PATH=/usr/local/flexlm/license_utilities_xilinx/linux_flexlm_v11.13.1.3/lnx64.o
#export LD_LIBRARY_PATH=/opt/Xilinx/Vivado/2018.1/bin/unwrapped/lnx64.o

# adding in path for glibc-2.14
export LD_LIBRARY_PATH=/opt/glibc-2.14/lib
#$LD_LIBRARY_PATH/lmgrd.sh -c /usr/share/Xilinx/xilinx.lic -l /usr/share/Xilinx/licensing.log
#$LD_LIBRARY_PATH/lmgrd -c /usr/share/Xilinx/xilinx.lic -l /usr/share/Xilinx/licensing.log
/usr/local/flexlm/license_utilities_xilinx/lin_flexlm_v11.17.2.0/lnx64.o/lmgrd -c /usr/share/Xilinx/xilinx.lic -l /usr/share/Xilinx/licensing.log
