#!/usr/bin/env bash
# 切回原输入法。流程结束时一定要跑。
set -euo pipefail
. "$(dirname "$0")/lib.sh"
$ADB shell ime set "$DEFAULT_IME" >/dev/null
echo "已切回 $DEFAULT_IME"
