#!/bin/bash

RULES_ARRAY=(
    "MAP aaa.com 10.20.33.77"
    "MAP bbb.com 10.20.33.88"
)
RULES_STRING=$(IFS=, ; echo "${RULES_ARRAY[*]}")

# Chrome 高版本限制 file:// 加载 PAC，改用本地 HTTP 服务托管
while true; do
    PAC_PORT=$((18000 + RANDOM % 1000))
    lsof -ti :$PAC_PORT > /dev/null 2>&1 || break
done
# 在后台启动 HTTP 服务，记录 PID
python3 -m http.server -d "$HOME/.chrome-pac" $PAC_PORT > /dev/null 2>&1 &
PAC_SERVER_PID=$!

# Chrome 退出后自动关闭 PAC HTTP 服务
(
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --proxy-pac-url="http://127.0.0.1:$PAC_PORT/proxy.pac" \
    --user-data-dir="$HOME/.chrome-pac" \
    --host-resolver-rules="$RULES_STRING" \
    --no-first-run \
    > /dev/null 2>&1 &
  CHROME_PID=$!
  # 阻塞等待 Chrome 退出，Chrome 是本子 shell 的子进程，wait 可以正常追踪
  wait $CHROME_PID
  # Chrome 已退出，PAC HTTP 服务完成使命，随之关闭
  kill $PAC_SERVER_PID 2>/dev/null
) &


# 0. pac文件和MAP 结合使用，保证不受代理VPN的影响

# 1. 等 Chrome 打开后关闭它，再执行下面的命令

# 2. 复制扩展目录
#cp -r ~/Library/Application\ Support/Google/Chrome/Default/Extensions ~/.chrome-pac/Default/Extensions

# 3. 同时复制扩展的偏好设置（否则扩展可能无法正常加载）
#cp ~/Library/Application\ Support/Google/Chrome/Default/Preferences ~/.chrome-pac/Default/Preferences

#cp ~/Library/Application\ Support/Google/Chrome/Default/Secure\ Preferences ~/.chrome-pac/Default/Secure\ Preferences

