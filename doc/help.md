### 相关指令帮助

`fir help` 命令不仅可以运行在 `fir` 主命令上, 还可以运行在相应子命令上查看相关的帮助.

```sh
$ fir help
Commands:
  fir build_apk BUILD_DIR                       # Build Android app (alias: `ba`).
  fir build_ipa BUILD_DIR [options] [settings]  # Build iOS app (alias: `bi`).
  fir help                                      # Describe available commands or one specific command (aliases: `h`).
  fir info APP_FILE_PATH                        # Show iOS/Android app info, support ipa/apk file (aliases: `i`).
  fir login                                     # Login fir.im (aliases: `l`).
  fir mapping MAPPING_FILE_PATH                 # Upload app mapping file to BugHD.com (aliases: `m`).
  fir me                                        # Show current user info if user is logined.
  fir publish APP_FILE_PATH                     # Publish iOS/Android app to fir.im, support ipa/apk file (aliases: `...
  fir upgrade                                   # Upgrade fir-cli and quit (aliases: `u`).
  fir version                                   # Show fir-cli version number and quit (aliases: `v`).

Options:
  -T, [--token=TOKEN]              # User's API Token at fir.im
  -L, [--logfile=LOGFILE]          # Path to writable logfile
  -V, [--verbose], [--no-verbose]  # Show verbose
                                   # Default: true
  -q, [--quiet], [--no-quiet]      # Silence commands
  -h, [--help], [--no-help]        # Show this help message and quit
```
#### 全局参数说明

- `alias <short command>` 意味着可以用 alias 别名来代替该指令, 例如 `fir b`
- `-T` 用户在 fir.im 上的 api_token
- `-L` 指定 fir-cli 的输出 log, 默认为 STDOUT
- `-V` Verbose, 默认为输出所有信息( INFO 和 ERROR), 如果设置 `--no-verbose`, 则只输出 ERROR 信息
- `-q` 静默模式, 默认关闭
- `-h` 查看相关命令帮助
