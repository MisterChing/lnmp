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

# microseconds
function timeUS() {
    declare -i time_us
    if [[ $(isBusyBox) == "yes" ]]; then
        time_us=$(adjtimex | awk '/(time.tv_sec|time.tv_usec):/ { printf("%-9d", $2) }' | sed 's/ /0/g')  # add trailing zeros
    elif [[ x"$(uname)" == x"Darwin" ]]; then
        time_us=$(gdate +%s%6N)
    else
        time_us=$(date +%s%6N)
    fi
    echo $time_us
}

dest=$(( `date +%s`+ $total_s-1 ))  # total_s-1: trick reduce code & sys time cost
while [ `date +%s` -lt $dest ]; do
    start_us=$(timeUS)
    eval $cmd
    end_us=$(timeUS)
    cost_ms=$(awk "BEGIN{print ($end_us - $start_us)/1000000000.0}")
    sleep_us=$(( $step * 1000000000 - ($end_us - $start_us) ))
    if [ $sleep_us -gt 0 ]; then
      sleep $(awk "BEGIN{print ($sleep_us+0.0)/1000000000}")
      echo "cost_time: $cost_ms sleep_time: $(awk "BEGIN{print ($sleep_us+0.0)/1000000000}")"
    else
      echo "cost_time: $cost_ms no sleep"
    fi
done


#for (( i = 0; i < $total_s-1; i=$(($i+step)) )); do   # total_s-1: trick reduce code & sys time cost
#    echo ${i}
#    start_us=$(timeUS)
#    eval $cmd
#    end_us=$(timeUS)
#    cost_ms=$(awk "BEGIN{print ($end_us - $start_us)/1000000000.0}")
#    sleep_us=$(( $step * 1000000000 - ($end_us - $start_us) ))
#    if [ $sleep_us -gt 0 ]; then
#      sleep $(awk "BEGIN{print ($sleep_us+0.0)/1000000000}")
#      echo "cost_time: $cost_ms sleep_time: $(awk "BEGIN{print ($sleep_us+0.0)/1000000000}")"
#    else
#      echo "cost_time: $cost_ms no sleep"
#    fi
#done
