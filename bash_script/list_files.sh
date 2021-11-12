#!/bin/bash

function listFileFromDir() {
    if [ ! -d $1 ]; then
        return
    fi
    for file in `ls $1`; do
        if [ -d $1"/"$file ]; then
            listFileFromDir $1"/"$file
        else
            echo $1"/"$file
        fi
    done
}

for arg in $@; do
    listFileFromDir $arg
done

