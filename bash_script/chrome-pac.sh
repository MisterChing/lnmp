#!/bin/bash
#

RULES_ARRAY=(
    "MAP api.xxx.com 10.20.33.78"
    "MAP app.xxx.com 198.19.2.6"
)
RULES_STRING=$(IFS=, ; echo "${RULES_ARRAY[*]}")

#export TF_LITE_DISABLE_XNNPACK=1
  #--proxy-pac-url="file://$HOME/.chrome-pac/proxy.pac" \

/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --proxy-pac-url="file://$HOME/.chrome-pac/proxy.pac" \
  --user-data-dir="$HOME/.chrome-pac" \
  --host-resolver-rules="$RULES_STRING"
  --no-first-run \
  > /dev/null 2>&1 &


# 0. pac文件和MAP 结合使用，保证不受代理VPN的影响

# 1. 等 Chrome 打开后关闭它，再执行下面的命令

# 2. 复制扩展目录
#cp -r ~/Library/Application\ Support/Google/Chrome/Default/Extensions ~/.chrome-pac/Default/Extensions

# 3. 同时复制扩展的偏好设置（否则扩展可能无法正常加载）
#cp ~/Library/Application\ Support/Google/Chrome/Default/Preferences ~/.chrome-pac/Default/Preferences

#cp ~/Library/Application\ Support/Google/Chrome/Default/Secure\ Preferences ~/.chrome-pac/Default/Secure\ Preferences
