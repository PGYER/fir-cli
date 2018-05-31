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


# 重要提示

- 由于 CDN 厂商技术原因, 部分老版本用户会出现 579 错误,解决该问题请升级fir-cli 至最新版
- 由于部分地区上传时遇到的证书问题, 新版本默认忽略证书校验. 如需打开, 请在命令前加入`UPLOAD_VERIFY_SSL=1`
- 介于在ios 等编译越来越复杂化, fir-cli 自带的 `build_ipa` 编译功能较为简单, 不能很好的满足用户需求, 推荐用户使用 fastlane (fastlane gym)进行打包,生成好 ipa 文件后,再使用 `fir publish` 上传生成的ipa
- 现已添加 docker 版本, 具体请见 `Docker 运行 fir-cli ` 说明
- 关于因为境外到境内网络不佳的而在上传出现 `stream closed`的问题, 我们已经联系了 CDN 厂商处理, 并将超时时间改为了 300 (秒), 如需修改, 可传入环境变量 `FIR_TIMEOUT=xxx` 

## 文档

- [安装及常见安装问题](https://github.com/FIRHQ/fir-cli/blob/master/doc/install.md)
- [fir help 相关指令帮助](https://github.com/FIRHQ/fir-cli/blob/master/doc/help.md)
- [fir info 查看 ipa/apk 信息](https://github.com/FIRHQ/fir-cli/blob/master/doc/info.md)
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

## 在 flow.ci 中的 Docker 使用 fir-cli
```
# 方便之处是: 不需要安装 Ruby 环境只需要安装Docker环境就行把镜像 flowci/fir-cli 拉下来就能跑
# 不方便之处是: 不能使用 xcode 或者 gradle 编译代码，只能 publish 编译好的文件

curl https://raw.githubusercontent.com/FIRHQ/fir-cli/master/fir.sh -o /usr/local/bin/fir
chmod +x /usr/local/bin/fir

fir login token
fir help
```

## 最近更新
- (1.6.10) 增加显示release_id 以及 app_id
- (1.6.9) 取消了依赖 CFPropertyList 的具体版本号
- (1.6.8) 取消了远端回调, 改为本地callback

## 提交反馈

- 联系微信 `atpking` 

- 使用 Github 的 [Issue](https://github.com/FIRHQ/fir-cli/issues) 

