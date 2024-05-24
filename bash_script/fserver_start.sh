#!/bin/bash
fserver -l :3500 \
	-r /data1/share_file/ \
	--prefix file \
 	--upload-dir /data1/share_file/private_xup/ \
 	--mkdir-dir /data1/share_file/private_xup/ \
 	--delete-dir /data1/share_file/private_xup/ \
	--auth-dir /data1/share_file/private_xup/ \
	--user aaa:bbb \
	--hide-file start.sh \
	--hide-dir private_xup \
