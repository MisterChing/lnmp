#!/bin/bash
s=$1
printf "%s" ${s} | md5sum | cut -d' ' -f1
