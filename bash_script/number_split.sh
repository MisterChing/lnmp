#!/bin/bash

if [[ $# -lt 3 ]]; then
    echo "Usage: bash number_split.sh {\$start} {\$end} {\$pageSize}"
    exit 0
fi
start_seq=$1
end_seq=$2
page_size=$3

while [ $end_seq -ge $start_seq ]; do
    m=$start_seq
    n=$(( $start_seq+$page_size-1 ))
    if [ $n -gt $end_seq ]; then
        n=$end_seq
    fi
    echo $m $n
    start_seq=$(( $n+1 ))
done
