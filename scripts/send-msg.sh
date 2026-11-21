#!/usr/bin/env bash
# 触发输入法的发送动作（IME_ACTION_SEND），比点发送按钮稳。
set -euo pipefail
. "$(dirname "$0")/lib.sh"
require_focus || exit 1
$ADB shell am broadcast -a ADB_EDITOR_CODE --ei code 4 >/dev/null
