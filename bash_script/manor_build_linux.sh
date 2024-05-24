#!/bin/bash
set -x
if [ "x$(uname)" == "xDarwin" ]; then
    ROOT_DIR=$(greadlink -f $(dirname $0))
else
    ROOT_DIR=$(readlink -f $(dirname $0))
fi
rm -rf linux_tar && mkdir -p linux_tar
GOOS=linux GOARCH=amd64 go build -gcflags='all=-N -l' -o ./bin ./...
cp -R bin linux_tar
cp -R conf linux_tar
tar -zcvf linux_tar.tgz linux_tar
