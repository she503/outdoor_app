#!/bin/bash
set -ue

HOST_ARCH=$(uname -m | grep -w -q 'x86_64' && echo 'amd64' || echo 'arm64')
HUB_PATH="tonglu-docker.pkg.coding.net/tergeo-app/tergeo-app"
TERGEO_MODULE_NAME="tergeo-app"
VERSION="v2.0"

docker pull ${HUB_PATH}/${TERGEO_MODULE_NAME}_base_${HOST_ARCH}:${VERSION}

docker build --build-arg HOST_ARCH=${HOST_ARCH} --build-arg VERSION=${VERSION} -t ${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION} .

docker tag ${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION} ${HUB_PATH}/${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION}
docker push ${HUB_PATH}/${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION}

docker tag ${TERGEO_MODULE_NAME}_${HOST_ARCH}:${VERSION} ${HUB_PATH}/${TERGEO_MODULE_NAME}_${HOST_ARCH}:latest
docker push ${HUB_PATH}/${TERGEO_MODULE_NAME}_${HOST_ARCH}:latest