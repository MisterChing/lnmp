#!/bin/bash
dir=$1
php -S $(ipconfig getifaddr en0):9999 -t ${dir}
