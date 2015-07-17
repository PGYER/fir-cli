FIR.im CLI
---

[![Join the chat at https://gitter.im/FIRHQ/fir-cli](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/FIRHQ/fir-cli?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
![Build Status Images](https://travis-ci.org/FIRHQ/fir-cli.svg)

> FIR.im CLI 可以通过指令查看, 上传, 编译应用

## 使用入门
### 从安装入手

FIR.im CLI 使用 Ruby 构建，只要安装相应 ruby gem 即可:

```shell
$ sudo gem install fir-cli
```

如果出现无法安装的现象, 请先升级下系统自带的 gem 包后再执行命令安装 fir-cli

```shell
sudo gem update --system
```

如果出现无法安装的现象, 请先升级下系统自带的 gem 包后再执行命令安装 fir-cli

```shell
sudo gem update --system
```

安装后，你可以在命令行执行指令

```shell
$ fir
Commands:
  fir build_ipa BUILD_DIR [options] [settings]  # Build iOS app (alias: 'b').
  fir help                                      # Describe available commands or one specific command.
  fir info APP_FILE_PATH                        # Show iOS/Android app's info, support ipa/apk file (aliases: 'i').
  fir login                                     # Login FIR.im (aliases: 'l').
  fir publish APP_FILE_PATH                     # Publish iOS/Android app to FIR.im, support ipa/apk file (aliases: 'p').
  fir upgrade                                   # Upgrade FIR-CLI and quit (aliases: u).
  fir version                                   # Show FIR-CLI version number and quit (aliases: v)

Options:
  -T, [--token=TOKEN]              # User's token at FIR.im
  -L, [--logfile=LOGFILE]          # Path to writable logfile
  -V, [--verbose], [--no-verbose]  # Show verbose
                                   # Default: true
  -q, [--quiet], [--no-quiet]      # Silence commands
  -h, [--help], [--no-help]        # Show this help message and quit
```

### 参数说明

- `alias <short command>` 意味着可以用 alias 别名来代替该指令, 例如 `fir b`
- `-T` 用户在 FIR.im 上的 token, `publish` 需要使用此参数
- `-L` 指定 FIR-CLI 的输出 log, 默认为 STDOUT
- `-V` Verbose, 默认为输出所有信息( INFO 和 ERROR), 如果设置 `--no-verbose`, 则只输出 ERROR 信息
- `-q` 静默模式, 默认关闭
- `-h` 查看帮助

### 发布一个应用

输入下面的指令便可轻松发布应用, 支持 ipa 和 apk 文件

```shell
$ fir p path/to/application -T YOUR_FIR_TOKEN
```

如果在此之前, 已经使用 `fir login` 命令登录过, 则可省略 `-T` 参数

```shell
> I, [2015-02-28T23:14:40.312010 #36861]  INFO -- : Publishing app.......
> I, [2015-02-28T23:14:45.312000 #36861]  INFO -- : ✈ -------------------------------------------- ✈
> I, [2015-02-28T23:14:48.311900 #36861]  INFO -- : Converting app's icon......
> I, [2015-02-28T23:14:48.311900 #36861]  INFO -- : Uploading app's icon......
> I, [2015-02-28T23:14:48.311900 #36861]  INFO -- : Uploading app......
> ..........
> I, [2015-02-28T23:14:46.312000 #36861]  INFO -- : ✈ -------------------------------------------- ✈
> I, [2015-02-28T23:14:48.311900 #36861]  INFO -- : Published succeed: http://fir.im/xxx
```

### 方便一点

如果觉得每次都输入 `-T` 很不方便, 那么可使用 `login` 命令

```shell
$ fir l
```

这时系统会提示输入用户 token, 用户 token 可在[这里](http://fir.im/user/info)查看

```shell
> Please enter your FIR.im token:
> I, [2015-03-01T18:26:42.718715 #38624]  INFO -- : Login succeed, current  user's email: xxx@fir.im

```

### 编译并获得 ipa
> 该指令 `build_ipa` 对 `xcodebuild` 原生指令进行了封装, 将常用的参数名简化, 支持全部的自带参数及设置, 同时输出符号表 .dSYM 文件.

```
$ fir build_ipa path/to/project -o path/to/output
> I, [2015-02-28T23:14:33.501293 #36861]  INFO -- : Building......
> I, [2015-02-28T23:14:33.501400 #36861]  INFO -- : ✈ -------------------------------------------- ✈
> I, [2015-02-28T23:14:38.311632 #36861]  INFO -- : Build settings from command line:
> ..........
> I, [2015-02-28T23:14:38.312012 #36861]  INFO -- : Build Success
```

### 复杂一点
```
$ fir b path/to/workspace -o path/to/output -w -C Release -t allTargets GCC_PREPROCESSOR_DEFINITIONS="FOO=bar"
```

该指令在指向的目录中，找到第一个 workspace 文件，对其进行编译。使用 `Release` 设置，编译策略为 `allTargets`，同时设置了预编译参数 `FOO`。

### 一步, 从源代码到 FIR.im
> 只需要输入 -p -T

```
$ fir build_ipa path/to/project -o path/to/output -p -T YOUR_FIR_TOKEN
> I, [2015-02-28T23:14:33.501293 #36861]  INFO -- : Building......
> I, [2015-02-28T23:14:33.501400 #36861]  INFO -- : ✈ -------------------------------------------- ✈
> I, [2015-02-28T23:14:38.311632 #36861]  INFO -- : Build settings from command line:
> ..........
> I, [2015-02-28T23:14:38.312012 #36861]  INFO -- : Build Success
> I, [2015-02-28T23:14:40.312010 #36861]  INFO -- : Publishing app.......
> I, [2015-02-28T23:14:45.312000 #36861]  INFO -- : ✈ -------------------------------------------- ✈
> ..........
> I, [2015-02-28T23:14:46.312000 #36861]  INFO -- : ✈ -------------------------------------------- ✈
> I, [2015-02-28T23:14:48.311900 #36861]  INFO -- : Published succeed: http://fir.im/xxx
```

## 需要帮助?

输入以下指令获取全面功能介绍

```shell
$ fir -h
$ fir publish -h
```

如果还有疑问随时发邮件至[fir-cli](mailto: hi@fir.im)

## 永远使用最新功能

下面的指令会自动更新 FIR-CLI

```shell
$ fir upgrade
```

随时更新以使用最新功能

## 提交反馈

[使用 github issue 即可](https://github.com/FIRHQ/fir-cli/issues)
