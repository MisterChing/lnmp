#!/bin/bash
host=$1
port=$2
if [ "${port}" == "" ]; then
    #tcpdump -i any host ${host} -nn -A
    tcpdump -i any host ${host} -tttt -nnv
else
    #tcpdump -i any host ${host} and port ${port} -nn -A
    tcpdump -i any host ${host} and port ${port} -tttt -nnv
fi
