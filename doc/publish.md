### fir publish

`fir publish` 命令用于可以发布应用到 fir.im, 支持 ipa 和 apk 文件.

```sh
$ fir publish --help
Usage:
  fir publish APP_FILE_PATH

Options:
  -s, [--short=SHORT]              # Set custom short link
  -c, [--changelog=CHANGELOG]      # Set changelog
  -Q, [--qrcode], [--no-qrcode]    # Generate qrcode
  -m, [--mappingfile=MAPPINGFILE]  # App mapping file
  -P, [--proj=PROJ]                # Project id in BugHD.com if upload app mapping file
      [--open], [--no-open]        # true/false if open for everyone, the default is: true
                                   # Default: true
      [--password=PASSWORD]        # Set password for app
  -T, [--token=TOKEN]              # User's API Token at fir.im
  -L, [--logfile=LOGFILE]          # Path to writable logfile
  -V, [--verbose], [--no-verbose]  # Show verbose
                                   # Default: true
  -q, [--quiet], [--no-quiet]      # Silence commands
  -h, [--help], [--no-help]        # Show this help message and quit
```

相关参数详解:

- `-s` 参数, 自定义发布后的短链接地址.
- `-c` 参数, 自定义发布时的 changelog, 支持字符串与文件两种方式, 即 `--changelog='this is changelog'` 和 `--changelog='/Users/fir-cli/changelog'`.
- `-Q` 参数, 是否生成发布后二维码, 默认为不生成, 加上 `-Q` 参数后会在当前目录生成一张二维码图片, 扫描该图片即可下载该应用.
- `-m` 参数, 上传当前应用的符号表文件, 配合 `-P` 参数使用.
- `-P` 参数, [BugHD.com](http://bughd.com) 上相对应的 Project id.
- `--open` 参数, 设置发布后的应用是否开放给所有人下载, 默认为开放, 关闭开放使用 `--no-open` 参数.
- `--password` 参数, 设置发布后的应用密码

