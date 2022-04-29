#!/bin/bash
set -e

CMD=$*

# Initialize the Build Environment
# set the builder ouput to /opt/yocto/build as we dont want to taint the cloned repository.
cd poky
source oe-init-build-env /opt/yocto/build
cp -rf /opt/yocto/conf /opt/yocto/build

echo
echo "##################################################"
echo "#  Build completed                               #"
echo "#                                                #"
echo "#  To build run $>                               #"
echo "#     bitbake core-image-minimal                 #"
echo "#                                                #"
echo "#  To emulate run $>                             #"
echo "#     runqemu qemuarm nographic                  #"
echo "#                                                #"
echo "##################################################"
echo

if [ -n "$CMD" ]; then
    echo "Running $> ${CMD}"
    $CMD
fi
