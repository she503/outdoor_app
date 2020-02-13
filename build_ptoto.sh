#!/bin/bash

set -ue
CURRENT_PATH=$(cd `dirname $0`; pwd)
PRE_PATH=${CURRENT_PATH}/..
cd ${CURRENT_PATH}

function gen_protobuf {
    cd ${CURRENT_PATH}
    cd ${CURRENT_PATH}/${1}
    echo "proto path: ${1}"
    for pb_h in $(find ./ -name "*.pb.h");do  
        rm ${pb_h}  
    done
    for pb_cc in $(find ./ -name "*.pb.cc");do  
        rm ${pb_cc}  
    done
         
    cd ${PRE_PATH}
    protoc -I=${PWD} -I=${CURRENT_PATH}/${1} --cpp_out=${PWD} ${CURRENT_PATH}/${1}/*.proto
    cd ${CURRENT_PATH} 
}

gen_protobuf "proto"