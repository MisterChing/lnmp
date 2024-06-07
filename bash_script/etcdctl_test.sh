#!/bin/bash
etcdctl --endpoints=172.27.3.69:4001 "$@"
