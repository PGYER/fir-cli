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
- 由于部分地区上传时遇到的证书问题, 新版本默认忽略证书校验. 如需打开, 请在命令前加入`UPLOAD_VERIFY_SSL=1`
- 介于在ios 等编译越来越复杂化, fir-cli 自带的 `build_ipa` 编译功能较为简单, 不能很好的满足用户需求, 推荐用户使用 fastlane (fastlane gym)进行打包,生成好 ipa 文件后,再使用 `fir publish` 上传生成的ipa

## 文档

- [安装及常见安装问题](https://github.com/FIRHQ/fir-cli/blob/master/doc/install.md)
- [fir help 相关指令帮助](https://github.com/FIRHQ/fir-cli/blob/master/doc/help.md)
- [fir info 查看 ipa/apk 信息](https://github.com/FIRHQ/fir-cli/blob/master/doc/info.md)
- [fir login & fir me 登录相关](https://github.com/FIRHQ/fir-cli/blob/master/doc/login.md)
- [fir publish 发布应用到 fir.im](https://github.com/FIRHQ/fir-cli/blob/master/doc/publish.md)
- [fir upgrade 升级相关](https://github.com/FIRHQ/fir-cli/blob/master/doc/upgrade.md)

## Docker 使用 fir-cli
```
# 方便之处是: 不需要安装 Ruby 环境只需要安装Docker环境就行把镜像 flowci/fir-cli 拉下来就能跑
# 不方便之处是: 不能使用 xcode 或者 gradle 编译代码，只能 publish 编译好的文件

curl https://raw.githubusercontent.com/FIRHQ/fir-cli/master/fir.sh -o /usr/local/bin/fir
chmod +x /usr/local/bin/fir

fir login token
fir help
```
## 近期计划(2018年03-04月)
- 集成 fastlane gym ,取代原有的 build_ipa 功能
- 增加上传完毕后反馈 release_id 
- 修复 changelog 不能换行的问题
- 完善docker 版本, 用户可以直接挂载文件目录上传

## 提交反馈

- 联系微信 `atpking` 

- 使用 Github 的 [Issue](https://github.com/FIRHQ/fir-cli/issues) 

