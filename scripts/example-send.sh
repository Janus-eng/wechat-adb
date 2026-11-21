#!/usr/bin/env bash
# 端到端示例：在已打开的微信聊天页发一条消息。
# 用法: example-send.sh "消息内容" [输入框 y 坐标，默认 2150]
set -euo pipefail
. "$(dirname "$0")/lib.sh"
msg="${1:?用法: example-send.sh \"消息\" [输入框y]}"
y="${2:-2150}"
here="$(dirname "$0")"

require_focus || exit 1

# 1. 点输入框拿焦点
$ADB shell input tap 540 "$y"
sleep 0.6

# 2. 输入
"$here/type-zh.sh" "$msg"
sleep 0.3

# 3. 发送
"$here/send-msg.sh"
sleep 0.3

# 4. 收尾：切回原输入法
"$here/restore-ime.sh"
