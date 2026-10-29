#!/bin/bash

RULES_ARRAY=(
    "MAP aaa.com 10.20.33.77"
    "MAP bbb.com 10.20.33.88"
)
RULES_STRING=$(IFS=, ; echo "${RULES_ARRAY[*]}")

BYPASS_LIST_ARRAY=(
    "aaa.com"
    "bbb.com"
)
BYPASS_LIST_STRING=$(IFS=, ; echo "${BYPASS_LIST_ARRAY[*]}")

/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --user-data-dir="$HOME/.chrome-pac" \
    --proxy-server=http://127.0.0.1:7890,direct:// \
    --proxy-bypass-list="$BYPASS_LIST_STRING" \
    --host-resolver-rules="$RULES_STRING" \
    --no-first-run \
    > /dev/null 2>&1 &


# 0. 使用固定本地代理，指定域名绕过代理，MAP 规则保持不受代理 VPN 影响

# 1. 等 Chrome 打开后关闭它，再执行下面的命令

# 2. 复制扩展目录
#cp -r ~/Library/Application\ Support/Google/Chrome/Default/Extensions ~/.chrome-pac/Default/Extensions

# 3. 同时复制扩展的偏好设置（否则扩展可能无法正常加载）
#cp ~/Library/Application\ Support/Google/Chrome/Default/Preferences ~/.chrome-pac/Default/Preferences

#cp ~/Library/Application\ Support/Google/Chrome/Default/Secure\ Preferences ~/.chrome-pac/Default/Secure\ Preferences

