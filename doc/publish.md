### fir publish

`fir publish` 命令用于可以发布应用到 fir.im, 支持 ipa 和 apk 文件.

```sh
Usage:
  fir publish APP_FILE_PATH

Options:
  -s, [--short=SHORT]                                                        # 设置short
  -c, [--changelog=CHANGELOG]                                                # 设置更新内容, 可是文件地址也可直接是内容
  -Q, [--qrcode], [--no-qrcode]                                              # 生成二维码图片在当前目录
      [--need-ansi-qrcode], [--no-need-ansi-qrcode]                          # 
  -R, [--need-release-id], [--no-need-release-id]                            # 在下载地址中包含具体版本(警告, 每个app 最多保留30个版本, 超过后会失效最老的版本)
  -H, [--force-pin-history], [--no-force-pin-history]                        # 将版本留在下载页(即在新版本上传后, 下面仍然有旧版本的二维码可以引导)
  -S, [--skip-update-icon], [--no-skip-update-icon]                          # 跳过更新图标
      [--specify-icon-file=SPECIFY_ICON_FILE]                                # 指定更新图标
      [--skip-fir-cli-feedback], [--no-skip-fir-cli-feedback]                # 跳过 用来做统计fir-cli的反馈(用于改进fir-cli)
      [--specify-app-display-name=SPECIFY_APP_DISPLAY_NAME]                  # 指定app 名称
  -N, [--switch-to-qiniu], [--no-switch-to-qiniu]                            # 切换到七牛线路上传(当上传较慢时, 可试试这个)
      [--oversea-turbo], [--no-oversea-turbo]                                # 海外加速(需联系微信 atpking 开通)
  -m, [--mappingfile=MAPPINGFILE]                                            # mappingfile
  -D, [--dingtalk-access-token=DINGTALK_ACCESS_TOKEN]                        # 上传完毕后 若发送至钉钉, 则填写钉钉的webhook 的access_token
      [--dingtalk-custom-message=DINGTALK_CUSTOM_MESSAGE]                    # 自定义钉钉消息 (针对钉钉新版webhook 需要校验的时候, 可以做关键字)
      [--dingtalk-at-phones=DINGTALK_AT_PHONES]                              # 钉钉  at 某人手机号
      [--dingtalk-at-all], [--no-dingtalk-at-all]
      [--feishu-access-token=FEISHU_ACCESS_TOKEN]                            # 飞书的webhook 的access_token
      [--feishu-custom-message=FEISHU_CUSTOM_MESSAGE]                        # 自定义飞书消息
      [--wxwork-webhook=WXWORK_WEBHOOK]                                      # 企业微信的 webhook 地址 (注意这里与 access_token 只需要填写一个参数即可)
      [--wxwork-access-token=WXWORK_ACCESS_TOKEN]                            # 企业微信的 webhook access_token (注意这里与 access_token 只需要填写一个参数即可)
      [--wxwork-custom-message=WXWORK_CUSTOM_MESSAGE]                        # 企业微信 的自定义消息
      [--wxwork-pic-url=WXWORK_PIC_URL]                                      # 企业微信的图片链接, best size is 1068x455
      [--open], [--no-open]                                                  # 是否下载可见, 默认open
      [--password=PASSWORD]                                                  # 下载页面密码, 默认为空
      [--bundletool-jar-path=BUNDLETOOL_JAR_PATH]                            # (beta) 上传AAB 文件的特殊指令: upload aab file command:  to specify bundletool.jar if command bundletool can not run directly
      [--auto-download-bundletool-jar], [--no-auto-download-bundletool-jar]  # (beta) 上传AAB 文件的特殊指令: upload aab file command: would download bundletool when invoke bundletool failure
  -T, [--token=TOKEN]                                                        # betaqr.com(fir.im) 账户的 API_TOKEN
  -L, [--logfile=LOGFILE]                                                    # Path to writable logfile
  -V, [--verbose], [--no-verbose]                                            # Show verbose
                                                                             # Default: true
  -q, [--quiet], [--no-quiet]                                                # Silence commands
  -h, [--help], [--no-help]                                                  # Show this help message and quit

Description:
  `publish` command will publish your app file to fir.im, also the command support to publish app's short & changelog.

  Example:

  $ fir p <app file path> [-c <changelog> -s <custom short link> -Q -T <your api token>]

  $ fir p <app file path> [-c <changelog> -s <custom short link> --password=123456 --open=false -Q -T <your api token>]

  $ fir p <app file path> [-c <changelog> -s <custom short link> -m <mapping file path> -P <bughd project id> -Q -T <your
  api token>]
```



