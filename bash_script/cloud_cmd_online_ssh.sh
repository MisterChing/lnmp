#!/bin/bash
auth=$(go_cookies xxx.com | grep 'Authorization=\S*;' -o | awk -F'=' '{print $2}' | awk -F';' '{print $1}' | sed 's/%20/ /g')
echo $auth
export PARAM_AUTH=$auth

# 接收命令参数
CMD_TO_RUN="$1"
echo $CMD_TO_RUN
export PARAM_CMD="$CMD_TO_RUN"

/usr/bin/expect -c '
set params $env(PARAM_AUTH)
set timeout 30
set pAuth1 [lindex $params 0]
set pAuth2 [lindex $params 1]
set cmd_to_run $env(PARAM_CMD)


spawn ssh -p 2222 xxxx@xxxx
expect {
    "JWT Token" {
        send "$pAuth1 $pAuth2\r"
        exp_continue
    }
    "您收藏的应用列表" {
        send "1111111\r"
        exp_continue
    }
    "请输入您要进入的集群的行号" {
        send "1\r"
        exp_continue
    }
    "请输入您要进入pod的行号" {
        send "1\r"
        # 等待登录成功，出现提示符
        expect -re "Welcome"

        # 如果提供了命令，则执行
        if {$cmd_to_run != ""} {
            send "$cmd_to_run\r"
        }
    }
}


interact
'
