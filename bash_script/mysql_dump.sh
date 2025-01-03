#!/bin/bash
sql=$1
#echo "$sql"
mysql -h127.0.0.1 -P3306 -uxxx -pxxxx dbname -e "${sql}" -B
