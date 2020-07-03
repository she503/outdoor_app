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

cd build/android-build/bin/ && cp QtApp-debug.apk tergeo_app.apk
cd ${CURRENT_PATH}

HUB_URL="https://tonglu-generic.pkg.coding.net/plugins-hub"
curl -T build/android-build/bin/tergeo_app.apk \
    -u ${CURL_USER}:${CURL_PASSWORD} \
    "${HUB_URL}/tergeo_app/app.apk?version=latest"

rm build/android-build/bin/tergeo_app.apk
