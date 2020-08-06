#!/bin/bash
set -ue

HOST_ARCH=$(uname -m | grep -w -q 'x86_64' && echo 'amd64' || echo 'arm64')
HUB_PATH="tonglu-docker.pkg.coding.net/plugins-hub/tergeo-apps"
TERGEO_MODULE_NAME="tergeo_app"
VERSION="latest"

docker pull ${HUB_PATH}/tergeo_app_base_${HOST_ARCH}:${VERSION}
docker pull ${HUB_PATH}/tergeo_app_execute_${HOST_ARCH}:${VERSION}

docker build --build-arg HOST_ARCH=${HOST_ARCH} --build-arg VERSION=${VERSION} -t ${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION} .

docker tag ${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION} ${HUB_PATH}/${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION}

