#!/bin/bash

if [[ $# -lt 3 ]]; then
    echo "Usage: bash video_split.sh {\$origin_video} {\$from} {\$to}"
    exit 0
fi
ori_video=$1
start_s=$2
end_s=$3
cut_video=${ori_video%.*}_cut.${ori_video##*.}
#ffmpeg -ss $start_s -i $ori_video -to $end_s -c copy -copyts $cut_video
ffmpeg -ss $start_s -i $ori_video -to $end_s -c copy $cut_video



#合并视频
# ffmpeg -f concat -i filelist.txt -c copy output.mp4
