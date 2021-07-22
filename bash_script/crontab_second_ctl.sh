#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Usage: bash(not sh) crontab_second.sh {\$step} command..."
    exit 0
fi
step=$1 && shift

cmd=`printf "%q " "$@"`

function isBusyBox() {
    echo | busybox md5sum &>/dev/null && echo yes || echo no
}

function timeMS() {
    declare -i time_ms
    if [[ $(isBusyBox) == "yes" ]]; then
        time_ms=$(adjtimex | awk '/(time.tv_sec|time.tv_usec):/ { printf("%06d", $2) }')
    elif [[ "x$(uname)" == "xDarwin" ]]; then
        time_ms=$(gdate +%s%6N)
    else
        time_ms=$(date +%s%6N)
    fi
    echo $time_ms
}

for (( i = 0; i < 60; i=$(($i+step)) )); do
    echo ${i}
    start_ms=$(timeMS)
    eval $cmd
    end_ms=$(timeMS)
    time_cost=$(($step * 1000000 - ($end_ms - $start_ms)))
    if [ $time_cost -gt 0 ]; then
      sleep $(awk "BEGIN{print ($time_cost+0.0)/1000000}")
      echo "sleep time: $(awk "BEGIN{print ($time_cost+0.0)/1000000}")"
    else
      echo "no sleep"
    fi
done
