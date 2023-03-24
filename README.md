✈ fir.im-cli
----

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/FIRHQ/fir-cli/master/LICENSE.txt)
[![最新版本的版本号](https://badge.fury.io/rb/fir-cli.svg)](http://badge.fury.io/rb/fir-cli)

fir.im-cli 可以通过指令查看, 上传, iOS/Android 应用.

![fir-cli](http://7rf35s.com1.z0.glb.clouddn.com/fir-cli-new.gif)


# 请注意
- 如果您遇到了任何fir-cli 使用上的问题, 建议您首先使用 `gem install fir-cli ` 升级到最新版本的 fir-cli, 目前最新版本是 [![最新版本的版本号](https://badge.fury.io/rb/fir-cli.svg)](http://badge.fury.io/rb/fir-cli), 您要是不确定的话, 可以使用 `fir version` 查看当前版本号


- 如果您在安装 fir-cli 过程中出现了各种问题, 但是着急使用的话, 现也有一个go 版本的 go-fir-cli 供大家使用, 无需安装依赖, 可以直接使用. 具体请访问  [https://github.com/PGYER/go-fir-cli](https://github.com/PGYER/go-fir-cli). 注意! 该版本功能并不与fir-cli 完全重合, 具体使用方式请参考该项目的 readme 文件.
- 我们也提供 docker 版本的 fir-cli, 具体使用方式参见 **Docker 运行 fir-cli** 章节

# 最近更新
- (2.0.20) 新增参数 --save_uploaded_info, 可以将上传的结果存入当前目录下的 fir-cli-upload-info.json 文件中, 方便集成其他功能
- (2.0.19) 修正了上传的图标不显示的问题
- (2.0.18) 修复域名导致的飞书发送失败的问题
- (2.0.17) 增加了上传百分比显示
- (2.0.16) 更新了 thor
- (2.0.15) 更换了 API 域名
- (2.0.14) 第三方通知加入了 app 类型, 第三方报错将忽略异常继续运行
- (2.0.13) 修正了企业微信通知的bug
- (2.0.12) 修复因为钉钉机器人不再支持base64导致无法显示二维码，另外开始支持钉钉加签方式的鉴权， 参数为 --dingtalk_secret
- (2.0.11) 兼容了 ruby 3.0
- (2.0.10) 飞书支持了 V2 版本的机器人推送
- (2.0.9) publish 支持了 企业微信通知 可以使用 --wxwork_access_token 或 --wxwork_webhook, 增加了回调超时时间至20秒
- (2.0.8) publish 支持 飞书通知, 可使用 `feishu_access_token` 和 `feishu_custom_message`, 详情见 `fir publish --help`
- (2.0.7) 修复了提示 token 错误的问题
- (2.0.6) 修复了因为文件读取方式变化而导致的文件找不到不报错的问题
- (2.0.5) 因为深信服 的黑名单误判, 将 api 切换到了备用域名
- (2.0.4) 修复了 cdn 不支持 patch 方法透传, 导致在修改 app 信息的时候返回的 400 错误
- (2.0.3.3) 试图打印出错的body内容
- (2.0.3.2) 将返回下载地址转化为了绑定的域名
- (2.0.3.1) 因为域名问题, fir-cli切换到了备用域名上.  老版本用户 运行 `gem update fir-cli` 即可
- (2.0.3) 增加 dingtalk_at_phones, 钉钉通知可 at 用户手机号, 以逗号,分割.  此命令需配合 `dingtalk_access_token` 使用
- (2.0.3) 增加 dingtalk_at_all, 钉钉通知可 at 所有人, 此命令需配合 `dingtalk_access_token` 使用
- (2.0.3) 增加海外加速参数 --oversea_turbo, 需要使用该功能的小伙伴请微信联系我, 我来开通
- (2.0.2) 有限支持 aab 文件上传, 强依赖 `bundletool` 工具, 具体请参见参数 `--bundletool_jar_path` 和 `--auto_download_bundletool_jar`
- (2.0.1) publish 支持 新参数 `specify_app_display_name`, 指定 app 显示名称
- (2.0.1) publish 支持 新参数 `need_ansi_qrcode`, 在控制台直接打印二维码, jenkins 用户可能需要使用 `AnsiColor Plugin` 插件配合
- (2.0.1) publish 支持 新参数 `dingtalk_custom_message`, 可以在钉钉通知里增加自定义消息, 此命令需配合 `dingtalk_access_token` 使用
- (2.0.1) publish 支持 新参数 `skip_fir_cli_feedback`, 可禁止 fir-cli 发送统计信息
- (1.7.4) publish 使用更快的存储商, 加速上传速度, 若感觉没以前可使用 参数 `switch_to_qiniu` 恢复
- (1.7.4) 支持了在fastlane 直接调用, 具体请参见 [https://github.com/FIRHQ/fastlane-plugin-fir_cli](https://github.com/FIRHQ/fastlane-plugin-fir_cli)
- (1.7.3) publish 支持 新参数 force_pin_history, 可以 将上传的版本, 固定在下载页面上(当大于最大固定版本数后, 会挤掉最老的固定版本) [2019年11月18日]
- (1.7.3) publish 支持 新参数 specify_icon_file_path, 可以直接指定 app 的 icon 图标文件 [2019年11月18日]
- (1.7.3) publish 支持 新参数 skip_update_icon, 可以略过更新app图标 [2019年11月18日]
- (1.7.1) 官方支持 钉钉推送, 使用方法为 在publish 中增加 --dingtalk_access_token=xxxxxxxxxxxxxxxxxxx (或者 -D=xxxxxxx)  [2019年05月06日]
- (1.7.1) 官方支持 上传完毕后, 返回精确的版本的下载地址, 使用方案为 在 publish 后增加 --need_release_id (特定版本支持近期30个以内的任意版本. 如有更多历史版本需要回溯, 可向线上客服或者 微信 atpking 进行申请特殊处理某app, 我们会根据使用情况酌情增加) [2019年05月06日]
- (1.7.0) 已过期 build_ipa 功能, 推荐用户使用 fastlane (fastlane gym)进行打包,生成好 ipa 文件后,再使用 `fir publish` 上传生成的ipa [2019年03月21日]


## 热门问题

### 啥是 钉钉 / 企业微信 / 飞书 的 `access_token` ?

就是回调地址中的长得最像 access_token 的东西

```
钉钉: https://oapi.dingtalk.com/robot/send?access_token=xxxxx
就是 xxx 那部分

企业微信: https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxx-xxxx-xxxx-xxxx-xxxxx
就是 xxxxx-xxxx-xxxx-xxxx-xxxxx  那部分

https://open.feishu.cn/open-apis/bot/hook/xxxxxxxxxxxxxxxxxxx

就是 xxxxxxxxxxxxxxxx 那部分

```





### 如何配合 jenkins 使用?

参见 blog [http://blog.betaqr.com/use-fir-cli-in-jenkins/](http://blog.betaqr.com/use-fir-cli-in-jenkins/)

这里有个快速检查脚本, 可以在 jenkins 中新建一个 脚本, 进行检查

```
#!/bin/bash --login

rvm list   # 确保 rvm 正确安装, 如果直接通过系统安装ruby, 可以注释此行
ruby -v  # 查看 ruby 的版本, 请确保大于 2.4.0
gem install fir-cli  # 现场安装fir-cli , 如果安装过, 则会略过
fir -v  # 查看 fir-cli 的版本

# 在这里执行 fir publish xxxxx
```


### 在 Circle CI, Travis CI 或 Github Actions 等境外服务上, 有概率超时, 能否解决?

fir-cli 在 2.0.18 版本已经支持自动判别用户是否是海外上传, 如果是海外ip, 则上传自动进行海外加速.

[已废弃]2.0.3 版本 及其以上, 可以申请海外加速内测资格, 开启后可以使用海外加速上传   `--oversea_turbo`


更多细节请参考 [https://github.com/FIRHQ/fir-cli/issues/260](https://github.com/FIRHQ/fir-cli/issues/260)

### 可以在 fastlane 里用么?

可以直接在命令行里调用,也可以安装 fastlane 的配套插件 fir_cli 具体请参见 [https://github.com/FIRHQ/fastlane-plugin-fir_cli](https://github.com/FIRHQ/fastlane-plugin-fir_cli)

### 日志换行有问题

可以将日志先输出成一个文本, 之后 --changelog=这个本文   即可实现changlog换行

### 图标解析有问题

可以在 publish 的时候使用 --specify_icon_file_path=xxx  来自己指定图标文件 或者使用  --skip_update_icon  来跳过图标文件的上传

### aab 文件能否上传?

能, 但是 aab 文件手机上并不能直接安装, 需要通过桌面使用 `bundletool` 工具来生成对应手机的 `apk` 包.

fir-cli 提供对 aab 文件有限程度支持的上传与下载. 在使用 fir-cli 上传 aab 文件时, 需要满足三个条件任意一条

1. 系统本身已经通过 `brew install bundletool` 等手段, 可以在命令行里直接调用 `bundletool`
2. 上传时指定了 `--bundletool_jar_path` 参数, 参数给出了 bundletool.jar 包的地址, 且命令行可以直接调用 `java` 指令
3. 能够保证 `https://github.com/google/bundletool/releases/download/#{version}/bundletool-all-#{version}.jar` 地址不被墙, 使用`--auto_download_bundletool_jar` 可以下载 `bundletool`


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
docker run -e API_TOKEN=您的token -v 您的上传文件的目录的绝对路径:/tmp firhq/fir-cli:latest publish /tmp/你的文件

# 如 `docker run -e API_TOKEN=xxxxxxxe -v /Users/atpking/Desktop:/tmp firhq/fir-cli:latest publish  /tmp/1.apk`

# 实际含义是把我的桌面挂载到 docker 里的 /tmp 目录  之后上传 docker 文件里的 /tmp/1.apk
# 也可以修改为其他目录
```

## 提交反馈

- 联系微信 `atpking`, 请注明 "fir-cli 交流"

- 使用 Github 的 [Issue](https://github.com/FIRHQ/fir-cli/issues)

## 特别感谢

- 感谢 sparkrico 提供修正的 https://github.com/sparkrico/ruby_apk 解决了 android 解析的问题
- 感谢 fabcz 同学对企业微信的通知的支持 https://github.com/FIRHQ/fir-cli/pull/277

## 鼓励维护

hia~ hia~ hia~
