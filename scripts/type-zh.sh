#!/usr/bin/env bash
# 用 ADB Keyboard 输入文字（中文可用）。
# 用法: type-zh.sh "文字"
set -euo pipefail
. "$(dirname "$0")/lib.sh"
text="${1:?用法: type-zh.sh \"要输入的文字\"}"

$ADB shell ime set "$ADB_IME" >/dev/null
sleep 0.4

if [ "${#text}" -gt 200 ]; then
  b64="$(printf '%s' "$text" | base64 -w0)"
  $ADB shell "am broadcast -a ADB_INPUT_B64 --es msg '$b64'" >/dev/null
else
  # 整个命令必须用双引号包住，否则中文和空格会被 shell 拆坏
  $ADB shell "am broadcast -a ADB_INPUT_TEXT --es msg '$text'" >/dev/null
fi
