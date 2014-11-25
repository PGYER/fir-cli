FIR.im 命令行工具
---
###安装
```shell
gem install fir-cli
```
###指令文档
####帮助
> 以下指令可以获取帮助

```shell
fir help
```

> 以下指令获取具体指令的帮助

- `COMMAND`：具体的一个指令，如`publish`，`update`
```shell
fir help COMMAND
```

####登录
> 以下指令通过用户`USER_TOKEN`登录，已登录用户可以在[这里](http://fir.im/user/info)上可以查看自己的令牌。

```shell
fir login USER_TOKEN
```

####获取应用文件的信息
> 以下指令可以显示应用文件的信息，支持 ipa 和 apk 文件。

- `-v`：可选，显示更多信息
- `-f`：可选，显示托管在 [FIR.im](http://fir.im) 的信息
```shell
fir info APP_FILE_PATH [-f] [-v]
```

####设置全局信息
> 以下指令可以设置全局信息. 

- `-r`：可选，默认发布都会使用企业证书签名
- `-t TOKEN`：可选，设置登录用户的令牌（作用和`fir loging USER_TOKEN`一样）
- `-e EMAIL`：可选，设置用户使用企业签名服务的默认邮件地址
```shell
fir config [-r] [-t TOKEN] [-e EMAIL]
```

####企业证书签名
> 以下指令使用 [resign.tapbeta.com](http://resign.tapbeta.com) 进行企业证书签名

- `INPUT_IPA_FILE`：待签名的 ipa 文件
- `OUTPUT_IPA_FILE`：签名后的输出文件
- `-e EMAIL`：可选，设置使用签名服务的邮件地址，不填则使用全局设置
```shell
fir resign INTPUT_IPA_FILE OUTPUT_IPA_FILE [-e EMAIL]
```

####发布应用至 [FIR.im](http://fir.im)
> 以下指令将指定应用文件发布到 [FIR.im](http://fir.im)，支持 ipa 和 apk 文件。

- `-r`：可选，设置此开关将首先企业签名，之后发布到 [FIR.im](http://fir.im)
- `-s SHORT`：可选，指定发布应用的短地址
- `-t USER_TOKEN`：可选，设定发布应用的帐号，未设置则使用全局设置
- `-c CHANGE_LOG`：可选，设置发布的发布日志
```shell
fir publish APP_FILE_PATH [-r] [-s SHORT] [-t USER_TOKEN] [-c CHANGE_LOG]
```


