#!/bin/bash
set -ue
CURRENT_PATH=$(cd `dirname $0`; pwd)
cd ${CURRENT_PATH}

BUILD_FOLDER="build"

INSTALL_FOLDER="install"
if [ -d "${INSTALL_FOLDER}" ];then
cd ${INSTALL_FOLDER} && rm ./* -rf && cd ${CURRENT_PATH} 
fi
if [ ! -d "${INSTALL_FOLDER}" ];then
mkdir ${INSTALL_FOLDER}
fi

cp -r build/tergeo_app install/
cp -rf ${CURRENT_PATH}/install/* /tergeo/