#!/bin/bash
echo $1
aria2c --header User-Agent: Chrome -s15 -x8 "$1"
