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

# 重大提醒
- fir.im 更换域名后, 需要升级至 `fir-cli` >= `2.0.4` 有部分用户反馈 2.0.2 无法直接使用 `gem update fir-cli` 升级到 2.0.4, 则可以尝试卸载后重新安装, 即 `gem uninstall fir-cli` 后 `gem install fir-cli` 


# 最近更新
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

2.0.3 版本 及其以上, 可以申请海外加速内测资格, 开启后可以使用海外加速上传   `--oversea_turbo`


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
