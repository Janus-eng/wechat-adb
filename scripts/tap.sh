#!/usr/bin/env bash
# 点击坐标，默认要求微信在前台。
# 用法: tap.sh <x> <y>    （FORCE=1 可跳过前台检查）
set -euo pipefail
. "$(dirname "$0")/lib.sh"
x="${1:?用法: tap.sh <x> <y>}"
y="${2:?用法: tap.sh <x> <y>}"
if [ "${FORCE:-0}" != "1" ]; then require_focus || exit 1; fi
$ADB shell input tap "$x" "$y"
