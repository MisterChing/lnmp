#!/bin/bash

function readLines() {
    if [ ! -f $1 ]; then
        return
    fi
    for line in `cat $1`; do
        echo $line
    done
}

for arg in $@; do
    readLines $arg
done
