#!/usr/bin/env bash
# 启动微信并确认进了前台。
set -euo pipefail
. "$(dirname "$0")/lib.sh"
$ADB shell monkey -p "$WECHAT_PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1 || true
sleep 3
cur="$(focus_pkg)"
echo "前台: $cur"
[ "$cur" = "$WECHAT_PKG" ] || { echo "微信没到前台，先手动解锁或处理弹窗" >&2; exit 1; }
