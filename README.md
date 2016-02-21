✈ fir.im-cli
---

![Build Status Images](https://travis-ci.org/FIRHQ/fir-cli.svg)
[![Code Climate](https://codeclimate.com/github/FIRHQ/fir-cli/badges/gpa.svg)](https://codeclimate.com/github/FIRHQ/fir-cli)
[![Test Coverage](https://codeclimate.com/github/FIRHQ/fir-cli/badges/coverage.svg)](https://codeclimate.com/github/FIRHQ/fir-cli/coverage)
[![Gem Version](https://badge.fury.io/rb/fir-cli.svg)](http://badge.fury.io/rb/fir-cli)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/FIRHQ/fir-cli?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

fir.im-cli 可以通过指令查看, 上传, 编译 iOS/Android 应用.

![fir-cli](http://7rf35s.com1.z0.glb.clouddn.com/fir-cli-new.gif)

## 安装

### OS X 安装

在安装前需要确保 **OS X command line tools** 已经被提前安装好:

```sh
$ xcode-select --install
```

fir.im-cli 使用 Ruby 构建, 无需编译, 只要安装相应 ruby gem 即可(如果出现相关权限不足的错误, 请在命令行前加上 `sudo`):

```sh
$ gem install fir-cli
```

**注意: 如果你的系统是 Mac OS X 10.11 以后的版本, 由于10.11引入了 `rootless`, 无法直接安装 fir-cli, 有以下三种解决办法:**

1\. 使用 [Homebrew](http://brew.sh/) 及 [RVM](https://rvm.io/) 安装 Ruby, 再安装 fir-cli(推荐)

```sh
# Install Homebrew:
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install RVM:
$ \curl -sSL https://get.rvm.io | bash -s stable --ruby

$ gem install fir-cli
```

2\. 指定 fir-cli 中 bin 文件的 PATH

```sh
$ export PATH=/usr/local/bin:$PATH;gem install -n /usr/local/bin fir-cli
```

3\. 重写 Ruby Gem 的 bindir

```sh
$ echo 'gem: --bindir /usr/local/bin' >> ~/.gemrc
$ gem install fir-cli
```

### Linux 安装

需要提前安装好 Ruby 版本 > 1.9.3

```sh
$ gem install fir-cli
```

**注意: 如果出现 `ERROR:  While executing gem ... (Gem::RemoteFetcher::FetchError)` 的错误, 请先更换 Ruby 的淘宝源(由于国内网络原因, 你懂的), 并升级下系统自带的 gem**

```sh
$ gem sources --remove https://rubygems.org/
$ gem sources -a https://ruby.taobao.org/
$ gem sources -l
*** CURRENT SOURCES ***

https://ruby.taobao.org
# 请确保只有 ruby.taobao.org, 如果有其他的源, 请 remove 掉

gem update --system
gem install fir-cli
```

## 使用说明

### fir help 使用说明

`fir help` 命令不仅可以运行在 `fir` 主命令上, 还可以运行在相应子命令上查看相关的帮助

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

### fir publish 使用说明

fir publish 命令可以轻松发布应用到 fir.im, 支持 ipa 和 apk 文件.

```sh
$ fir publish path/to/application -T YOUR_FIR_TOKEN
```

如果需要上传 changelog, 自定义 short 地址, 设置密码, 设置公开访问权限, 上传符号表, 生成二维码等功能, 可以使用 `fir publish -h`查看相应的帮助

### fir login 使用说明

如果觉得每次上传都输入 `-T` 很不方便, 那么可使用 `login` 命令

```sh
$ fir login
```

这时系统会提示输入用户 API token, 用户的 API token 可在 **[这里](http://fir.im/apps/apitoken)** 的右上角查看

```sh
Please enter your fir.im API Token:
I, [2015-08-26T10:10:28.235295 #6833]  INFO -- : Login succeed, previous user's email: xxx@xxx.com
I, [2015-08-26T10:10:28.245083 #6833]  INFO -- : Login succeed, current  user's email: xxx@xxx.com
I, [2015-08-26T10:10:28.245152 #6833]  INFO -- :
```

### fir build 使用说明

该指令分为两个不同的指令, `build_ipa` 和 `build_apk`, 可以编译 ipa 及 apk 应用并上传到 fir.im

#### 编译 ipa

`build_ipa` 对 `xcodebuild` 原生指令进行了封装, 将常用的参数名简化, 支持全部的自带参数及设置, 同时输出符号表 dSYM 文件.

编译 project

```
$ fir build_ipa path/to/project -o path/to/output
```

编译 workspace

```sh
$ fir build_ipa path/to/workspace -o path/to/output -w -C Release -t allTargets GCC_PREPROCESSOR_DEFINITIONS="FOO=bar"
```

该指令在指向的目录中，找到第一个 workspace 文件，对其进行编译。使用 `Release` 设置，编译策略为 `allTargets`，同时设置了预编译参数 `FOO`。

编译用 CocoaPods 做依赖管理的 .ipa 包

```sh
$ fir build_ipa path/to/workspace -w -S <scheme name>
```

#### 编译用 Gradle 打包 apk

```sh
# 简单打包
$ fir build_apk path/to/project

# 打包并上传
$ fir ba <project dir> [-o <apk output dir> -c <changelog> -p -Q -T <your api token>]

# 打包指定的 flavor
$ fir ba <project dir> [-f <flavor> -o <apk output dir> -c <changelog> -p -Q -T <your api token>]

# 打包指定的 git branch
$ fir ba <git ssh url> [-B develop -o <apk output dir> -c <changelog> -p -Q -T <your api token>]
```

#### 编译并且上传至 fir.im

只需要输入 `-p -T` 即可

```sh
$ fir build_ipa/build_apk path/to/project -o path/to/output -p -T YOUR_FIR_TOKEN -c YOUR_CHANGELOG
```

如果需要更详细的使用说明, 可以使用 `fir build_ipa/build_apk -h`查看相应的帮助

### fir mapping 使用说明

该指令可以上传符号表至 [BugHD.com](http://bughd.com) 所对应的项目, 目前已经支持 dSYM 和 txt 两种格式的符号表文件上传, 有以下三种方法上传:

> 指定 version 和 build 上传:

```sh
$ fir m <mapping file path> -P <bughd project id> -v <app version> -b <app build> -T <your api token>
```

> 在 publish 的时候自动上传:

```sh
$ fir p <app file path> -m <mapping file path> -P <bughd project id> -T <your api token>
```
> 在 build_ipa 的时候自动上传:

```sh
$ fir b <project dir> -P <bughd project id> -M -p -T <your api token>
```

如果需要更详细的使用说明, 可以使用 `fir mapping -h`查看相应的帮助

### fir me 使用说明

该指令可以查看当前使用者

```sh
$ fir me
I, [2015-11-02T03:03:04.933645 #29886]  INFO -- : Login succeed, current user's email: xxxx
I, [2015-11-02T03:03:04.933756 #29886]  INFO -- : Login succeed, current user's name:  xxxx
I, [2015-11-02T03:03:04.933787 #29886]  INFO -- :
```

### fir upgrade 使用说明

该指令用于升级最新版本的 fir-cli

```sh
$ fir upgrade
```

## 提交反馈

直接使用 Github 的 [Issue](https://github.com/FIRHQ/fir-cli/issues) 即可.

## 捐赠支持

如果你觉得 fir-cli 对你有所帮助, 欢迎微信打赏支持作者:smile:

![](http://7rf35s.com1.z0.glb.clouddn.com/coffee.png)

