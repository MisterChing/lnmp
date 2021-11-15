#!/bin/bash

if [[ $# -lt 3 ]]; then
    echo "Usage: bash(not sh) crontab_second.sh {\$total_second} {\$step} command..."
    exit 0
fi
total_s=$1 && shift
step=$1 && shift

cmd=`printf "%q " "$@"`

function isBusyBox() {
    echo | busybox md5sum &>/dev/null && echo yes || echo no
}

# nanoseconds
function timeNS() {
    declare -i time_ns
    if [[ $(isBusyBox) == "yes" ]]; then
        time_ns=$(adjtimex | awk '/(time.tv_sec|time.tv_usec):/ { printf("%-9d", $2) }' | sed 's/ /0/g')  # add trailing zeros
    elif [[ x"$(uname)" == x"Darwin" ]]; then
        time_ns=$(gdate +%s%N)
    else
        time_ns=$(date +%s%N)
    fi
    echo $time_ns
}

dest=$(( `date +%s`+ $total_s-1 ))  # total_s-1: trick reduce code & sys time cost
while [ `date +%s` -lt $dest ]; do
    start_ns=$(timeNS)
    eval $cmd
    end_ns=$(timeNS)
    cost_s=$(awk "BEGIN{print ($end_ns - $start_ns)/1000000000.0}")
    sleep_ns=$(( $step * 1000000000 - ($end_ns - $start_ns) ))
    if [ $sleep_ns -gt 0 ]; then
      sleep $(awk "BEGIN{print ($sleep_ns+0.0)/1000000000}")
      echo "cost_time: $cost_s sleep_time: $(awk "BEGIN{print ($sleep_ns+0.0)/1000000000}")"
    else
      echo "cost_time: $cost_s no sleep"
    fi
done


#for (( i = 0; i < $total_s-1; i=$(($i+step)) )); do   # total_s-1: trick reduce code & sys time cost
#    echo ${i}
#    start_ns=$(timeNS)
#    eval $cmd
#    end_ns=$(timeNS)
#    cost_s=$(awk "BEGIN{print ($end_ns - $start_ns)/1000000000.0}")
#    sleep_ns=$(( $step * 1000000000 - ($end_ns - $start_ns) ))
#    if [ $sleep_ns -gt 0 ]; then
#      sleep $(awk "BEGIN{print ($sleep_ns+0.0)/1000000000}")
#      echo "cost_time: $cost_s sleep_time: $(awk "BEGIN{print ($sleep_ns+0.0)/1000000000}")"
#    else
#      echo "cost_time: $cost_s no sleep"
#    fi
#done
