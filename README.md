fir.im-cli
---


![Build Status Images](https://travis-ci.org/FIRHQ/fir-cli.svg)
[![Code Climate](https://codeclimate.com/github/FIRHQ/fir-cli/badges/gpa.svg)](https://codeclimate.com/github/FIRHQ/fir-cli)
[![Test Coverage](https://codeclimate.com/github/FIRHQ/fir-cli/badges/coverage.svg)](https://codeclimate.com/github/FIRHQ/fir-cli/coverage)
[![Gem Version](https://badge.fury.io/rb/fir-cli.svg)](http://badge.fury.io/rb/fir-cli)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/FIRHQ/fir-cli?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

> fir.im-cli 可以通过指令查看, 上传, 编译应用

## 使用入门
### 从安装入手

fir.im-cli 使用 Ruby 构建，只要安装相应 ruby gem 即可:

```shell
$ sudo gem install fir-cli
```

如果出现无法安装的现象, 请先更换 Ruby 的淘宝源(由于国内网络原因, 你懂的), 并升级下系统自带的 gem

```shell
sudo gem sources --remove https://rubygems.org/
sudo gem sources -a https://ruby.taobao.org/
sudo gem sources -l
*** CURRENT SOURCES ***

https://ruby.taobao.org
# 请确保只有 ruby.taobao.org, 如果有其他的源, 请 remove 掉

sudo gem update --system
sudo gem install fir-cli
```

**注意: 如果你的系统是 mac OSX 10.11 以后的版本, 由于10.11引入了 `rootless`, 无法直接安装 fir-cli, 有以下四种解决办法:**

1\. 使用 [RVM](https://rvm.io/) 安装 Ruby, 再安装 fir-cli(推荐)

```shell
# Install RVM:
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ \curl -sSL https://get.rvm.io | bash -s stable --ruby

$ gem install fir-cli
```

2\. 指定 fir-cli 中 bin 文件的 PATH

```shell
$ export PATH=/usr/local/bin:$PATH;sudo gem install -n /usr/local/bin fir-cli
```

3\. 重写 Ruby Gem 的 bindir

```shell
$ echo 'gem: --bindir /usr/local/bin' >> ~/.gemrc
$ sudo gem install fir-cli
```

4\. 直接关闭 OSX 10.11 的 rootless(不推荐)

安装后，你可以在命令行执行指令

```shell
$ fir
Commands:
  fir build_apk BUILD_DIR                       # Build Android app (alias: 'ba').
  fir build_ipa BUILD_DIR [options] [settings]  # Build iOS app (alias: 'bi').
  fir help                                      # Describe available commands or one specific command.
  fir info APP_FILE_PATH                        # Show iOS/Android app's info, support ipa/apk file (aliases: 'i').
  fir login                                     # Login FIR.im (aliases: 'l').
  fir mapping MAPPING_FILE_PATH                 # Upload app's mapping file to BugHD.com (aliases: 'm').
  fir me                                        # Show current user info if user is logined.
  fir publish APP_FILE_PATH                     # Publish iOS/Android app to FIR.im, support ipa/apk file (aliases: 'p').
  fir upgrade                                   # Upgrade FIR-CLI and quit (aliases: u).
  fir version                                   # Show FIR-CLI version number and quit (aliases: v)

Options:
  -T, [--token=TOKEN]              # User's API Token at FIR.im
  -L, [--logfile=LOGFILE]          # Path to writable logfile
  -V, [--verbose], [--no-verbose]  # Show verbose
                                   # Default: true
  -q, [--quiet], [--no-quiet]      # Silence commands
  -h, [--help], [--no-help]        # Show this help message and quit
```

### 参数说明

- `alias <short command>` 意味着可以用 alias 别名来代替该指令, 例如 `fir b`
- `-T` 用户在 fir.im 上的 api_token, `publish` 需要使用此参数
- `-L` 指定 fir-cli 的输出 log, 默认为 STDOUT
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
I, [2015-08-26T10:08:35.447209 #6774]  INFO -- : Publishing app.......
I, [2015-08-26T10:08:35.447334 #6774]  INFO -- : ✈ -------------------------------------------- ✈
I, [2015-08-26T10:08:35.514378 #6774]  INFO -- : Fetching xxxx@fir.im uploading info......
I, [2015-08-26T10:08:35.692616 #6774]  INFO -- : Uploading app......
I, [2015-08-26T10:08:36.920226 #6774]  INFO -- : Updating devices info......
I, [2015-08-26T10:08:37.075149 #6774]  INFO -- : ✈ -------------------------------------------- ✈
I, [2015-08-26T10:08:37.075238 #6774]  INFO -- : Fetch app info from fir.im
I, [2015-08-26T10:08:37.235071 #6774]  INFO -- : Published succeed: http://fir.im/xxxx
I, [2015-08-26T10:08:37.235155 #6774]  INFO -- :
```

### 方便一点

如果觉得每次都输入 `-T` 很不方便, 那么可使用 `login` 命令

```shell
$ fir l
```

这时系统会提示输入用户 token, 用户 token 可在 **[这里](http://fir.im/user/info)** 查看

```shell
Please enter your fir.im API Token:
I, [2015-08-26T10:10:28.235295 #6833]  INFO -- : Login succeed, previous user's email: xxx@xxx.com
I, [2015-08-26T10:10:28.245083 #6833]  INFO -- : Login succeed, current  user's email: xxx@xxx.com
I, [2015-08-26T10:10:28.245152 #6833]  INFO -- :
```

### 编译并获得 ipa
> 该指令 `build_ipa` 对 `xcodebuild` 原生指令进行了封装, 将常用的参数名简化, 支持全部的自带参数及设置, 同时输出符号表 .dSYM 文件.

```
$ fir build_ipa path/to/project -o path/to/output
I, [2015-08-26T10:11:12.105103 #7167]  INFO -- : Building......
I, [2015-08-26T10:11:12.105175 #7167]  INFO -- : ✈ -------------------------------------------- ✈
I, [2015-08-26T10:11:18.500887 #7167]  INFO -- : Build settings from command line:

..........

I, [2015-08-26T10:11:18.535498 #7167]  INFO -- : Build Success
I, [2015-08-26T10:11:18.535704 #7167]  INFO -- :
```

### 复杂一点

```shell
$ fir bi path/to/workspace -o path/to/output -w -C Release -t allTargets GCC_PREPROCESSOR_DEFINITIONS="FOO=bar"
```

该指令在指向的目录中，找到第一个 workspace 文件，对其进行编译。使用 `Release` 设置，编译策略为 `allTargets`，同时设置了预编译参数 `FOO`。

### 编译用 CocoaPods 做依赖管理的 .ipa包

```shell
$ fir bi path/to/workspace -w -S <scheme name>
```

### 编译用 Gradle 打包 apk

```shell
$ fir ba path/to/project
```

### 一步, 从源代码到 fir.im
> 只需要输入 -p -T

```shell
$ fir build_ipa path/to/project -o path/to/output -p -T YOUR_FIR_TOKEN
I, [2015-08-26T10:11:59.687221 #7273]  INFO -- : Building......
I, [2015-08-26T10:11:59.687301 #7273]  INFO -- : ✈ -------------------------------------------- ✈
I, [2015-08-26T10:12:00.868774 #7273]  INFO -- : Build settings from command line:

..........

I, [2015-08-26T10:12:00.893819 #7273]  INFO -- : Build Success
I, [2015-08-26T10:12:00.894051 #7273]  INFO -- :
I, [2015-08-26T10:12:01.026832 #7273]  INFO -- : Publishing app.......
I, [2015-08-26T10:12:01.026905 #7273]  INFO -- : ✈ -------------------------------------------- ✈
I, [2015-08-26T10:12:01.098759 #7273]  INFO -- : Fetching im.fir.OnlyiPad@fir.im uploading info......
I, [2015-08-26T10:12:01.249832 #7273]  INFO -- : Uploading app......
I, [2015-08-26T10:12:01.859718 #7273]  INFO -- : Updating devices info......
I, [2015-08-26T10:12:02.015517 #7273]  INFO -- : ✈ -------------------------------------------- ✈
I, [2015-08-26T10:12:02.015588 #7273]  INFO -- : Fetch app info from fir.im
I, [2015-08-26T10:12:02.210391 #7273]  INFO -- : Published succeed: http://fir.im/xxxx
I, [2015-08-26T10:12:02.210459 #7273]  INFO -- :
I, [2015-08-26T10:12:02.210520 #7273]  INFO -- :
```

### 上传符号表

有以下三种方式上传符号表至 [BugHD.com](http://bughd.com) 所对应的项目, 目前已经支持 dSYM 和 txt 两种格式的符号表文件上传

> 指定 version 和 build 上传:

```shell
$ fir m <mapping file path> -P <bughd project id> -v <app version> -b <app build> -T <your api token>
```

> 在 publish 的时候自动上传:

```shell
$ fir p <app file path> -m <mapping file path> -P <bughd project id> -T <your api token>
```
> 在 build_ipa 的时候自动上传:

```shell
$ fir b <project dir> -P <bughd project id> -M -p -T <your api token>
```

## 需要帮助?

输入以下指令获取全面功能介绍

```shell
$ fir -h
$ fir publish -h
```

如果还有疑问随时发邮件至 [fir-cli](mailto: dev@fir.im)

## 永远使用最新功能

下面的指令会自动更新 fir-cli

```shell
$ fir upgrade
```

随时更新以使用最新功能

## 提交反馈

[使用 github issue 即可](https://github.com/FIRHQ/fir-cli/issues)
