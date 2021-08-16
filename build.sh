#!/bin/bash
CWD=$(pwd)
PROFILE=$CWD
WORKDIR=/tmp/koompi-os

[[ -d $WORKDIR ]] && sudo rm -rf $WORKDIR && mkdir -p $WORKDIR

sudo ${CWD}/mkarchiso -v -w $WORKDIR $PROFILE
