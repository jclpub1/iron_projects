#!/bin/bash
###
### Start lmgrd for mgcld(mentor graphics)
###
# MODEL_TECH=/opt/modelsim/modelsim_dlx/linuxpe
MODEL_TECH=/share/modelsim_de_v2019.4/modelsim_dlx/linuxpe
LM_LICENSE_FILE=/usr/local/flexlm/licenses/license.dat
#PATH=$PATH:/opt/ModSim/modelsim_dlx/linuxpe
PATH=$PATH:$MODEL_TECH/../bin
export PATH LM_LICENSE_FILE
#/opt/ModSim/modelsim_dlx/linuxpe/lmgrd mgcld  >/tmp/mgcld 2>&1
$MODEL_TECH/lmgrd mgcld  >/tmp/mgcld 2>&1



