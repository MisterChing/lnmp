#!/bin/bash
#https://github.com/nicksherron/cookies
auth=$(go_cookies baidu.com | grep 'Authorization=\S*;' -o | awk -F'=' '{print $2}' | awk -F';' '{print $1}' | sed 's/%20/ /g')
echo $auth
export PARAM_AUTH=$auth


/usr/bin/expect -c '
set params $env(PARAM_AUTH)
set timeout 30
set pAuth1 [lindex $params 0]
set pAuth2 [lindex $params 1]

spawn ssh -p 2222 xxx@10.160.xxx.xxx
expect {
    "JWT Token" {
        send "$pAuth1 $pAuth2\r"
    }
}
interact
'

