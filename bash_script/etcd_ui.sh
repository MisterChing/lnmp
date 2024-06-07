#!/bin/bash
if [ "$1"x == "start"x ]; then
    nohup /Users/ching/local/etcdkeeper_test/etcdkeeper -p 9901 & > /dev/null 2>&1
    nohup /Users/ching/local/etcdkeeper_prod/etcdkeeper -p 9902 & > /dev/null 2>&1
elif [ "$1"x == "stop"x ]; then
    ps -ef | grep etcdkeeper | grep -v grep | awk '{print $2}' | xargs kill
fi
