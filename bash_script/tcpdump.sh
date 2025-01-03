#!/bin/bash
set -x
host=$1
port=$2

if [ "${port}" == "" ]; then
    #tcpdump -i any host ${host} -tttt -nvv
    tcpdump -i any host ${host} -tttt -A
else
    #tcpdump -i any host ${host} and port ${port} -tttt -nvv
    tcpdump -i any host ${host} and port ${port} -tttt -A
fi

