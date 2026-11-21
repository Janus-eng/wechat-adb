# wechat-adb

用 adb 做微信界面自动化的实操记录和封装脚本。

不是逆向，不是 hook，不碰微信客户端：只用公开的 `adb` 命令和开源的
[ADB Keyboard](https://github.com/senzhk/ADBKeyBoard) 输入法，跟你手动点屏幕
是一回事，只是把手指换成了命令。

和 Appium、Auto.js、uiautomator 属于同一类做法。

## 这不是什么

- 不是破解，不修改客户端，不绕过任何鉴权
- 不抓包、不读数据库、不碰聊天记录存储
- 不适合群发、加粉、批量操作

## 适用范围

实测环境：**HyperOS + Android 15 + 微信最新版 + 小米机型**。
不同 ROM 的开关名称、输入框坐标、前台检测输出都可能不一样，脚本里凡是
跟这两样相关的地方都留了参数，别直接照抄数字。

## 为什么用 adb 而不是无障碍节点树

微信把无障碍节点树挡住了，`uiautomator dump` 和各类读屏自动化工具拿不到
界面内容。但 adb 的输入注入完全不经过无障碍层：

- `input tap` / `input swipe`：原始触摸事件
- `am broadcast` + ADB Keyboard：输入法层注入文字

所以节点树被屏蔽不影响这套方案。

## 快速开始

### 1. 手机端准备

开发者选项里全部打开：

- USB 调试
- 无线调试（记下 IP 和端口，**重启或重开都会变**）
- USB 调试（安全设置）—— 小米需要插 SIM + 登录小米账号才能打开

### 2. 装 ADB Keyboard

把 [ADBKeyBoard](https://github.com/senzhk/ADBKeyBoard) 的 APK 装上。
装第三方 APK 前记得开开发者选项里的「USB 安装」，否则会报
`INSTALL_FAILED_USER_RESTRICTED`。

### 3. 连接

```bash
adb connect 192.168.1.10:41234
adb devices
```

### 4. 用脚本

```bash
./scripts/check-focus.sh              # 看当前前台是哪个 App
./scripts/start-wechat.sh             # 启动微信并确认进了前台
./scripts/tap.sh 540 2150             # 点输入框（带前台校验）
./scripts/type-zh.sh "测试一下"        # 中文输入
./scripts/send-msg.sh                 # 发送
./scripts/restore-ime.sh              # 切回原输入法
```

端到端示例（在已打开的聊天页）：

```bash
./scripts/example-send.sh "测试一下"
```

## 踩坑记录

真正的价值都在这儿，详见 [docs/PITFALLS.md](docs/PITFALLS.md)。摘几条：

1. **坐标差几十像素就点不中**。1080×2400 下聊天输入框中心约在 `y=2150`，
   不是 2127。之前用 2127 一直没反应，被误判成「微信拦截了注入」，其实是
   根本没点到输入框。
2. **动手前必须确认前台**。不确认就注入文字，会打进别的 App（踩过两次：
   打进了自己的编辑器输入框、打进了浏览器）。
3. **发送用 `IME_ACTION_SEND`，别点发送按钮**。点按钮偶发不灵，广播稳定。
4. **ADBKeyBoard 用完要切回去**。不切的话用户自己打字会没有中文键盘。
5. **广播必须整体用双引号包住**，否则中文和空格会被 shell 拆坏。
6. **锁屏或切后台时不要注入**，先查前台和 `mInputShown`。

## 免责声明

微信的服务条款对自动化操作有限制。使用本仓库的任何脚本属于你个人的选择，
账号风险自负。建议：只在个人设备上使用、限制操作频率、不做群发和批量行为。

## 隐私

本仓库不含任何个人信息：没有手机号、微信号、聊天内容、IP、端口或密钥。
脚本里的坐标和包名都是通用值，你自己的设备参数请放在本地环境变量里，
不要提交。

## 许可

脚本部分 MIT。文中提到的 ADB Keyboard 遵循其自身许可。
