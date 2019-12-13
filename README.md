✈ fir.im-cli
----    

![Build Status Images](https://travis-ci.org/FIRHQ/fir-cli.svg)
[![Code Climate](https://codeclimate.com/github/FIRHQ/fir-cli/badges/gpa.svg)](https://codeclimate.com/github/FIRHQ/fir-cli)
[![Test Coverage](https://codeclimate.com/github/FIRHQ/fir-cli/badges/coverage.svg)](https://codeclimate.com/github/FIRHQ/fir-cli/coverage)
[![Gem Version](https://badge.fury.io/rb/fir-cli.svg)](http://badge.fury.io/rb/fir-cli)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/FIRHQ/fir-cli?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/FIRHQ/fir-cli/master/LICENSE.txt)

fir.im-cli 可以通过指令查看, 上传, iOS/Android 应用.

![fir-cli](http://7rf35s.com1.z0.glb.clouddn.com/fir-cli-new.gif)


# 最近更新
- (2.0.1) publish 支持 新参数 `specify_app_display_name`, 指定 app 显示名称
- (2.0.1) publish 支持 新参数 `need_ansi_qrcode`, 在控制台直接打印二维码, jenkins 用户可能需要使用 `AnsiColor Plugin` 插件配合
- (2.0.1) publish 支持 新参数 `dingtalk_custom_message`, 可以在钉钉通知里增加自定义消息, 此命令需配合 `dingtalk_access_token` 使用
- (2.0.1) publish 支持 新参数 `skip_fir_cli_feedback`, 可禁止 fir-cli 发送统计信息
- publish 使用更快的存储商, 加速上传速度, 若感觉没以前可使用 参数 `switch_to_qiniu` 恢复
- 支持了在fastlane 直接调用, 具体请参见 [https://github.com/FIRHQ/fastlane-plugin-fir_cli](https://github.com/FIRHQ/fastlane-plugin-fir_cli)
- publish 支持 新参数 force_pin_history, 可以 将上传的版本, 固定在下载页面上(当大于最大固定版本数后, 会挤掉最老的固定版本) [2019年11月18日]
- publish 支持 新参数 specify_icon_file_path, 可以直接指定 app 的 icon 图标文件 [2019年11月18日]
- publish 支持 新参数 skip_update_icon, 可以略过更新app图标 [2019年11月18日]
- 官方支持 钉钉推送, 使用方法为 在publish 中增加 --dingtalk_access_token=xxxxxxxxxxxxxxxxxxx (或者 -D=xxxxxxx)  [2019年05月06日]
- 官方支持 上传完毕后, 返回精确的版本的下载地址, 使用方案为 在 publish 后增加 --need_release_id (特定版本支持近期30个以内的任意版本. 如有更多历史版本需要回溯, 可向线上客服或者 微信 atpking 进行申请特殊处理某app, 我们会根据使用情况酌情增加) [2019年05月06日]
- 已过期 build_ipa 功能, 推荐用户使用 fastlane (fastlane gym)进行打包,生成好 ipa 文件后,再使用 `fir publish` 上传生成的ipa [2019年03月21日]
- 由于部分地区上传时遇到的证书问题, 新版本默认忽略证书校验. 如需打开, 请在命令前加入`UPLOAD_VERIFY_SSL=1`
- 现已添加 docker 版本, 具体请见 `Docker 运行 fir-cli ` 说明

## 热门问题

### 在 Circle CI, Travis CI 或 Github Actions 等境外服务上, 有概率超时, 能否解决?

由于监管要求, 我们必须将服务于存储放置在境内. 由于众所周知的原因, 国内外连通性的表现不太好, 虽然我们的存储服务商 阿里云 提供了 OSS 境外加速服务, 但是高达 1.25 元/GB 的传输成本确实我们也没办法负担. 

目前我们提供三种临时解决方案来缓解问题: 

1. 设置较长的超时时间 如 `FIR_TIMEOUT=300 fir publish xxxx`, 则可将超时时间设置为 300 秒.
2. 如果fir-cli 版本 >= 2.0.0, 也可在出现超时后, 使用 `--switch-to-qiniu` 来切换到我们的另外一条存储线路. 如 `fir publish xxxx.apk --switch-to-qiniu`, 多一条线路备选.
3. 如果确实对这方面服务要求很高, 则可购买我们的私有部署服务. 我们可以在 aws 上部署一套专供您使用, 具体情况可以与客服或者加我微信进行沟通.

更多细节请参考 [https://github.com/FIRHQ/fir-cli/issues/260](https://github.com/FIRHQ/fir-cli/issues/260)

### 可以在 fastlane 里用么?

可以直接在命令行里调用,也可以安装 fastlane 的配套插件 fir_cli 具体请参见 [https://github.com/FIRHQ/fastlane-plugin-fir_cli](https://github.com/FIRHQ/fastlane-plugin-fir_cli)


### 日志换行有问题

可以将日志先输出成一个文本, 之后 --changelog=这个本文   即可实现changlog换行

### 图标解析有问题

可以在 publish 的时候使用 --specify_icon_file_path=xxx  来自己指定图标文件 或者使用  --skip_update_icon  来跳过图标文件的上传

### 我想将 我上传的版本展示在下载的页面上

可以在 publish 的时候使用 --force_pin_history   这样 这个上传的版本即成为 "历史版本", 会在下载页面里一直显示. 当有新的版本上传后, 这个版本会作为 "历史版本" 在下载页面中展示. 

当版本设置为历史版本后, 用户可以直接下载指定的版本, 由于因成本原因, 一个 app 最多的 "历史版本" 为 30 个, 如果有用户有特殊需求, 可以与我们取得联系进行单独修改

当达到上限后, 如果继续标记 force_pin_history, 则历史版本的最老版本(以上传时间为准)会被移出历史版本列表

### 境外上传老出现 stream closed 

因为网络时延问题, 可传入环境变量 `FIR_TIMEOUT=xxx` 进行超时时间设置

### 愿意做持续集成,但技术上遇到较大阻碍

可以联系微信 `atpking`

## 文档

- [安装及常见安装问题](https://github.com/FIRHQ/fir-cli/blob/master/doc/install.md)
- [fir login & fir me 登录相关](https://github.com/FIRHQ/fir-cli/blob/master/doc/login.md)
- [fir publish 发布应用到 fir.im](https://github.com/FIRHQ/fir-cli/blob/master/doc/publish.md)
- [fir upgrade 升级相关](https://github.com/FIRHQ/fir-cli/blob/master/doc/upgrade.md)

## Docker 运行 fir-cli 

### 准备工作
1. 将自己需要的文件挂载到 docker 中, 之后即可直接运行
2. 将自己的 API_TOKEN 以环境变量的形式传入container 

### 如何运行

假设 我需要上传桌面的  1.apk 

```
docker run firhq/fir-cli:latest -e API_TOKEN=XXXX -v ./1.apk:1.apk publish 1.apk
```

## 提交反馈

- 联系微信 `atpking`, 请注明 "fir-cli 交流"

- 使用 Github 的 [Issue](https://github.com/FIRHQ/fir-cli/issues) 

## 特别感谢 

- 感谢 sparkrico 提供修正的 https://github.com/sparkrico/ruby_apk 解决了 android 解析的问题


## 鼓励维护

感谢支持

![luckin](luckin_coffee.png)
