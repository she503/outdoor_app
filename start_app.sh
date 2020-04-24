#!/bin/bash
set -ue
xhost +
IMAGE_NAME=tergeo-app_amd64:v2.0
NET_NAME=host
MODULE_NAME=tergeo_app-`date +%H%M%s`


docker run -it --rm \
  --privileged \
  --net ${NET_NAME} \
  --name ${MODULE_NAME} \
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  ${IMAGE_NAME} \
  /tergeo/tergeo_app
