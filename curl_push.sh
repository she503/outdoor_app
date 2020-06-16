#!/bin/bash
set -ue
CURRENT_PATH=$(cd `dirname $0`; pwd)
cd ${CURRENT_PATH}

CURL_USER=""
CURL_PASSWORD=""
ARGS=`getopt -o u:p: -al user:,password: -- "${@:1}"` 
eval set -- "$ARGS" 
while [ -n "$1" ]; do 
    case "$1" in 
        -u|--user) CURL_USER=$2; shift 2;;
        -p|--password) CURL_PASSWORD=$2; shift 2;;
        *) break;; 
    esac 
done

mkdir /tmp/tergeo_app -p 
cp build/android-build/bin/QtApp-debug.apk /tmp/tergeo_app

cd /tmp/tergeo_app
zip -r app.zip ./* 
cd ${CURRENT_PATH}

HUB_URL="https://tonglu-generic.pkg.coding.net/plugins-hub"
curl -T /tmp/tergeo_app/app.zip \
    -u ${CURL_USER}:${CURL_PASSWORD} \
    "${HUB_URL}/tergeo_app/app.zip?version=latest"

rm -r /tmp/tergeo_app