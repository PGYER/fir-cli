FIR.im CLI
---
> FIR.im CLI 可以通过指令查看、上传、编译应用，同时还集成了第三方网站 [resign.tapbeta.com](http://resign.tapbeta.com) 进行企业签名以方便 inhouse 测试。

## Changelog
### FIR-cli 0.1.8
- 支持 ruby 1.9.x
- 规范输出参数选项，支持无颜色信息输出
  -`--verbose=v|vv|vvv`：设置输出级别
  -`--quiet` 与 `--no-quiet`：设置是否不输出辅助信息
  -`--color` 与 `--no-color`：设置输出是否携带颜色信息
- 修复 ipa 应用图标不清晰问题
- 增加切换配置文件功能：使用此功能可以在多个用户中切换使用

## 使用说明
### 从安装入手
FIR.im CLI 使用 ruby 构建，只要安装相应 ruby gem 即可：
```shell
$ sudo gem install fir-cli
```
安装后，你可以在命令行执行指令
```shell
$ fir
> 欢迎使用 FIR.im 命令行工具，如需帮助请输入: fir help
Commands:
  fir config                            # 配置全局设置
  fir help [COMMAND]                    # Describe available commands or one specific command
  fir info APP_FILE_PATH                # 获取应用文件的信息（支持 ipa 文件和 apk 文件）
  fir login                             # 登录
  fir publish APP_FILE_PATH             # 将应用文件发布至 FIR.im（支持 ipa 文件和 apk 文件）
  fir resign IPA_FILE_PATH OUTPUT_PATH  # 使用 resign.tapbeta.com 进行企业签名
  fir upgrade                           # 更新 fir-cli 的所有组件
```

### 发布一个应用
输入下面的指令便可轻松发布应用
```shell
$ fir publish 应用路径
```
这时系统会提示输入用户 token
```shell
> 欢迎使用 FIR.im 命令行工具，如需帮助请输入: fir help
> 正在解析 ipa 文件...
> 正在获取 im.fir.juo@FIR.im 的应用信息...
请输入用户 token：
```
输入用户 token 后，系统会自动上传
```shell
请输入用户 token：xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> 上传应用...
> 上传应用成功
> 正在更新 fir 的应用信息...
> 更新成功
> 正在更新 fir 的应用版本信息...
> 更新成功
> http://fir.im/xxxxx
```

用户 token 可在[这里](http://fir.im/user/info)查看

### 方便一点
如果觉得每次都输入用户 token 很不方便，那么可使用登录命令

```shell
$ fir login
```
这时系统会提示输入用户 token
```shell
> 欢迎使用 FIR.im 命令行工具，如需帮助请输入: fir help
输入你的用户 token： 
```
输入用户 token，系统会自动获取你的用户 email
```shell
输入你的用户 token：xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> 设置用户邮件地址为: dy@fir.im
> 当前登陆用户为：xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```


### 需要企业签名？
很多开发者需要一个企业签名的应用，来让更多的用户参与到测试中，这种行为并不符合企业证书的使用规范。但是我们还是集成了第三方签名网站 [resign.tapbeta.com](http://resign.tapbeta.com) 来帮助我们的用户更方便的进行测试。

```shell
$ fir resign ipa文件路径 输出文件路径
```
这条指令会输出一段风险提示；如果没有设置邮件地址，这里会让你输入邮件地址。输入邮件地址后，便开始进行企业签名了
```
> 欢迎使用 FIR.im 命令行工具，如需帮助请输入: fir help
! resign.tapbeta.com 签名服务风险提示
! 无法保证签名证书的长期有效性，当某种条件满足后
! 苹果会禁止该企业账号，所有由该企业账号所签发的
! 证书都会失效。你如果使用该网站提供的服务进行应
! 用分发，请注意：当证书失效后，所有安装了已失效
! 证书签名的用户都会无法正常运行应用；同时托管在
! fir.im 的应用将无法正常安装。
请输入你的邮件地址： dy@fir.im
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
输入以下指令获取全面功能介绍
```shell
$ fir help
```
如果还有疑问随时发邮件至[fir-cli](mailto:fir-cli@fir.im)

### 永远使用最新功能
下面的指令会自动更新 fir-cli 及所有扩展命令至最新状态
```shell
$ fir upgrade
```
随时更新以使用最新功能

## 指令文档
### 帮助
> 以下指令用于获取帮助

```shell
fir help
```

> 以下指令用于获取更具体的帮助

- `COMMAND`：具体的一个指令，如`publish`，`update`
```shell
fir help COMMAND
```

### 切换配置文件
> 以下指令用于切换配置文件，一个用户可以拥有多个配置文件。用户所有全局设置都跟随配置文件的切换而变化

- `-d` 删除指定配置文件
```shell
fir profile PROFILE [-d]
```

### 登录
> 以下指令用于登录，登录后系统会从 FIR.im 自动获取你的邮件等信息。已登录用户在[这里](http://fir.im/user/info)可以找到自己的用户 token。

```shell
fir login
```
### 设置全局信息
> 以下指令用于全局设置。执行指令时如果不指明相应选项，会读取全局设置。

- `--token=TOKEN`：见`登录`
- `--resign`：见`第三方企业证书签名服务`
- `--email=EMAIL`：见`第三方企业证书签名服务`
- `--verbose=v|vv|vvv`：见`控制输出参数`
- `--quiet` 与 `--no-quiet`：见`控制输出参数`
- `--color` 与 `--no-color`：见`控制输出参数`
```shell
fir config [options]
```

### 获取应用文件的信息
> 以下指令用于显示应用信息，支持 ipa 和 apk 文件。

- `--all` 与 `--no-all`：可选，现实全部信息
- `--fir` 与 `--no-fir`：可选，显示托管在 [FIR.im](http://fir.im) 的信息
```shell
fir info APP_FILE_PATH [-a] [-f] [-v v|vv|vvv] [-q]
```



### 第三方企业证书签名服务
> 以下指令使用 [resign.tapbeta.com](http://resign.tapbeta.com) 进行企业证书签名

- `INPUT_IPA_PATH`：待签名的 ipa 文件路径
- `OUTPUT_IPA_PATH`：签名后的输出文件路径
- `--email=EMAIL`：可选，设置使用签名服务的邮件地址
```shell
fir resign INTPUT_IPA_FILE OUTPUT_IPA_FILE [--email=EMAIL]
```

### 发布应用至 [FIR.im](http://fir.im)
> 以下指令用于发布应用到 [FIR.im](http://fir.im)，支持 ipa 和 apk 文件。

- `--resign` 与 `--no-resign`：可选，此开关控制是否使用第三方企业签名服务，仅支持 ipa 文件
- `--short=SHORT`：可选，指定发布应用的短地址
- `--token=USER_TOKEN`：可选，设定发布应用的帐号，未设置则使用全局设置
- `--changelog=CHANGE_LOG`：可选，设置更新日志
```shell
fir publish APP_FILE_PATH [-r] [-s SHORT] [-t USER_TOKEN] [-c CHANGE_LOG]
```

### 更新全部指令
> 以下指令用于更新已安装的 fir-cli 指令集

```shell
fir upgrade
```

### 通用参数
#### 控制输出参数
> 几乎全部 FIR-cli 指令都支持下面的控制输出参数

- `--verbose=v|vv|vvv`：用于控制输出级别，`v`只输出以`!`开始的内容；`vv`输出以`!`或`>`开始的内容；`vvv`输出全部辅助信息。
- `--quiet` 与 `--no-quiet`：设置是否不输出全部辅助信息
- `--color` 与 `--no-color`：设置输出信息是否包含命令行颜色信息
