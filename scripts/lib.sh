#!/usr/bin/env bash
# 公共函数，其他脚本 source 它。
# 不要直接执行。

ADB="${ADB:-adb}"
WECHAT_PKG="${WECHAT_PKG:-com.tencent.mm}"
ADB_IME="${ADB_IME:-com.android.adbkeyboard/.AdbIME}"
DEFAULT_IME="${DEFAULT_IME:-com.baidu.input_mi/.ImeService}"

# 打印当前前台 App 的包名。不同 ROM 的 dumpsys 输出不同，这里取第一个匹配。
focus_pkg() {
  $ADB shell dumpsys window 2>/dev/null \
    | grep -m1 -E 'mCurrentFocus|mFocusedApp' \
    | sed -E 's/.*[ =]([A-Za-z0-9_.]+)\/[A-Za-z0-9_.$]+.*/\1/' \
    | tr -d '\r'
}

# 前台不是指定 App 时中止。用法: require_focus [包名]
require_focus() {
  local want="${1:-$WECHAT_PKG}" cur
  cur="$(focus_pkg)"
  if [ "$cur" != "$want" ]; then
    echo "前台是 [$cur]，不是 [$want]，已中止" >&2
    return 1
  fi
}

# 输入框是否正在显示（可选检查，部分 ROM 可用）
input_shown() {
  $ADB shell dumpsys input_method 2>/dev/null | grep -m1 -E 'mInputShown=(true|false)' \
    | grep -q 'mInputShown=true'
}
