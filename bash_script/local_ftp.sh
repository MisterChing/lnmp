#!/bin/bash
#ifconfig en0 | grep -E 'inet \d?' | awk '{print $2}'
dir=$1
php -S $(ipconfig getifaddr en0):9999 -t $dir
