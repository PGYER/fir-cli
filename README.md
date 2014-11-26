FIR.im CLI
---
> FIR.im CLI 提供了您使用中的一些基本功能，同时还集成了第三方网站 [resign.tapbeta.com](http://resign.tapbeta.com) 进行企业签名，方便开发者测试。更多功能还在开发中。

## 使用说明
### 从安装入手
FIR.im CLI 是用 ruby 构建，只要安装相应 ruby gem 即可：

```shell
gem install fir-cli
```

### 发布一个应用
输入下面的指令便可以发布一个 ipa 文件
```shell
fir publish ipa文件路径
```
这时系统会提示输入用户令牌

```shell
> 欢迎使用 FIR.im 命令行工具，如需帮助请输入: fir help
> 正在解析 ipa 文件...
> 正在获取 im.fir.juo@FIR.im 的应用信息...
请输入用户令牌：
> 上传应用...
> 上传应用成功
> 正在更新 fir 的应用信息...
> 更新成功
> 正在更新 fir 的应用版本信息...
> 更新成功
> http://fir.im/xxxxx
```

用户令牌可以在[这里](http://fir.im/user/info)查看

### 方便一点
如果觉得每次都输入用户令牌很不方便，那么可以使用登录命令

```shell
$ fir login 用户令牌
> 欢迎使用 FIR.im 命令行工具，如需帮助请输入: fir help
> 设置用户邮件地址为: xx@xx.xx
> 当前登陆用户为：用户令牌
```


### 需要企业签名？
很多开发者需要一个企业签名的应用，来让更多的用户参与到测试中，这种行为并不符合企业证书的使用规范。但是我们还是集成了第三方签名网站 [resign.tapbeta.com](http://resign.tapbeta.com) 帮助我们的用户更方便的进行测试。

```shell
$ fir resign ipa文件路径 输出文件路径
```
这条指令会输出一段风险提示，如果没有设置邮件地址，这里会让您输入邮件地址，等全部完成之后，便开始进行企业签名了
```
> 欢迎使用 FIR.im 命令行工具，如需帮助请输入: fir help
! resign.tapbeta.com 签名服务风险提示
! 无法保证签名证书的长期有效性，当某种条件满足后
! 苹果会禁止该企业账号，所有由该企业账号所签发的
! 证书都会失效。您如果使用该网站提供的服务进行应
! 用分发，请注意：当证书失效后，所有安装了已失效
! 证书签名的用户都会无法正常运行应用；同时托管在
! fir.im 的应用将无法正常安装。
请输入您的邮件地址： dy@fir.im
> 正在申请上传令牌...
> 正在上传...
> 正在排队...
> 正在签名...
> 正在下载到 /path/to/output.ipa...
```


### 一步到位
企业签名后自动发布到 [FIR.im](http://fir.im)
```shell
$ fir publish ipa文件路径 -r
```

### 需要帮助？
输入下面的指令可以获得全面的功能介绍
```shell
$ fir help
```
如果还有不清楚的欢迎随时发邮件至[fir-cli](mailto:fir-cli@fir.im)提出您的疑惑

### 永远使用最新的功能
下面的指令会自动更新 fir-cli 及所有扩展组件至最新状态
```shell
$ fir upgrade
```

## 指令文档
### 帮助
> 以下指令可以获取帮助

```shell
fir help
```

> 以下指令获取具体指令的帮助

- `COMMAND`：具体的一个指令，如`publish`，`update`
```shell
fir help COMMAND
```

### 登录
> 以下指令用于设置用户令牌：`USER_TOKEN`，已登录用户可以在[这里](http://fir.im/user/info)
上可以查看自己的令牌。

```shell
fir login USER_TOKEN
```

### 获取应用文件的信息
> 以下指令可以显示应用文件的信息，支持 ipa 和 apk 文件。

- `-a`：可选，现实全部信息
- `-f`：可选，显示托管在 [FIR.im](http://fir.im) 的信息
- `-v`：可选，设置输出级别，级别分为三个：`v`、`vv`、`vvv`，默认为`vv`
- `-q`：可选，安静模式，不输出任何信息
```shell
fir info APP_FILE_PATH [-f] [-v]
```

### 设置全局信息
> 以下指令可以进行全局设置。执行指令时如过不指明相应选项，会读区全局设置。

- `-r`：可选，如果设置了全局企业签名，发布默认将使用第三方企业签名服务
- `-v`：可选，如果设置了全局输出级别，各指令都采用该级别输出
- `-q`：可选，如果设置了全局静默模式，各指令均不输出辅助信息
- `-t TOKEN`：可选，设置登录用户的令牌（作用和`fir loging USER_TOKEN`一样）
- `-e EMAIL`：可选，设置用户使用企业签名服务的默认邮件地址
```shell
fir config [-r] [-t TOKEN] [-e EMAIL]
```

### 第三方企业证书签名服务
> 以下指令使用 [resign.tapbeta.com](http://resign.tapbeta.com) 进行企业证书签名

- `INPUT_IPA_PATH`：待签名的 ipa 文件路径
- `OUTPUT_IPA_PATH`：签名后的输出文件路径
- `-e EMAIL`：可选，设置使用签名服务的邮件地址
```shell
fir resign INTPUT_IPA_FILE OUTPUT_IPA_FILE [-e EMAIL]
```

### 发布应用至 [FIR.im](http://fir.im)
> 以下指令将指定应用文件发布到 [FIR.im](http://fir.im)，支持 ipa 和 apk 文件。

- `-r`：可选，此开关控制是否使用第三方企业签名服务，仅支持 ipa 文件
- `-s SHORT`：可选，指定发布应用的短地址
- `-t USER_TOKEN`：可选，设定发布应用的帐号，未设置则使用全局设置
- `-c CHANGE_LOG`：可选，设置发布的发布日志
```shell
fir publish APP_FILE_PATH [-r] [-s SHORT] [-t USER_TOKEN] [-c CHANGE_LOG]
```

### 更新全部指令
> 以下指令将更新所有安装的 fir-cli 指令集

```shell
fir upgrade
```

