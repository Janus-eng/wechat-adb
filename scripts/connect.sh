#!/usr/bin/env bash
# 连接手机无线调试。用法: connect.sh [IP:端口]
set -euo pipefail
ep="${1:-$(cat "$HOME/.android/last-endpoint.txt" 2>/dev/null || true)}"
if [ -z "$ep" ]; then
  echo "用法: $0 <手机IP:端口>" >&2
  exit 1
fi
adb connect "$ep"
mkdir -p "$HOME/.android"
printf '%s' "$ep" > "$HOME/.android/last-endpoint.txt"
adb devices
