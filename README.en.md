# wechat-adb

[简体中文](README.md) | **English**

Hands-on notes and helper scripts for driving WeChat over `adb`.

Not reverse engineering, not hooking, not modifying the client: just public
`adb` commands and the open-source [ADB Keyboard](https://github.com/senzhk/ADBKeyBoard)
IME. It does exactly what your finger does, only from a shell.

Same category as Appium, Auto.js or uiautomator.

## What this is not

- Not a crack, does not touch the app binary or its auth
- No packet capture, no database access, no reading of stored chats
- Not meant for bulk messaging or follower farming

## Tested on

HyperOS, Android 15, latest WeChat, Xiaomi hardware. Every ROM differs in
toggle names, input-box coordinates and foreground-detection output, so the
scripts expose those as arguments instead of hardcoding them.

## Why adb instead of the accessibility tree

WeChat hides its accessibility node tree, so `uiautomator dump` and
screen-reader style tools see nothing. adb input injection bypasses the
accessibility layer entirely:

- `input tap` / `input swipe` -- raw touch events
- `am broadcast` + ADB Keyboard -- text injection at the IME layer

## Quick start

1. Enable USB debugging, wireless debugging and USB debugging (Security settings)
   in Developer options. Note the wireless port: it changes on every reboot.
2. Install ADB Keyboard. Enable "Install via USB" first, or you get
   `INSTALL_FAILED_USER_RESTRICTED`.
3. `adb connect <phone-ip>:<port>`
4. Run the scripts:

```bash
./scripts/check-focus.sh
./scripts/start-wechat.sh
./scripts/tap.sh 540 2150
./scripts/type-zh.sh "hello"
./scripts/send-msg.sh
./scripts/restore-ime.sh
```

## Pitfalls

See [docs/PITFALLS.md](docs/PITFALLS.md). The short version:

1. Tens of pixels matter. On 1080x2400 the chat input sits around `y=2150`,
   not 2127. Missing it looks exactly like "WeChat blocks injection".
2. Always check the foreground app before injecting, or text lands in the
   wrong app.
3. Send with `IME_ACTION_SEND`, not by tapping the send button.
4. Switch the IME back afterwards, or the user has no Chinese keyboard.
5. Wrap the whole `am broadcast` command in double quotes, or the shell
   splits Chinese text and spaces.
6. Never inject while the screen is locked or the app is backgrounded.

## Disclaimer

WeChat's terms of service restrict automation. Using these scripts is your own
choice and your account is at your own risk. Personal devices only, keep the
frequency low, no bulk messaging.

## Privacy

No personal data in this repository: no phone number, WeChat ID, chat content,
IP, port or key material.

## License

Scripts are MIT.
