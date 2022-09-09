#!/bin/bash
host=$1
port=$2
if [ "${port}" == "" ]; then
    tcpdump -i any host ${host} -nn -A
else
    tcpdump -i any host ${host} and port ${port} -nn -A
fi
