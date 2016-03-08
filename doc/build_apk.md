#### fir build_apk

`fir build_apk` 指令用于编译用 Gradle 打包 apk, 并且支持直接从 Github/Gitlab 相关 repo 直接编译打包.

```sh
fir build_apk --help
Usage:
  fir build_apk BUILD_DIR

Options:
  -B, [--branch=BRANCH]            # Set branch if project is a git repo, the default is `master`
  -o, [--output=OUTPUT]            # APK output path, the default is: BUILD_DIR/build/outputs/apk
  -p, [--publish], [--no-publish]  # true/false if publish to fir.im
  -f, [--flavor=FLAVOR]            # Set flavor if have productFlavors
  -s, [--short=SHORT]              # Set custom short link if publish to fir.im
  -n, [--name=NAME]                # Set custom apk name when builded
  -c, [--changelog=CHANGELOG]      # Set changelog if publish to fir.im, support string/file
  -Q, [--qrcode], [--no-qrcode]    # Generate qrcode
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

```sh
# 简单打包
$ fir build_apk path/to/project

# 打包并上传
$ fir ba <project dir> [-o <apk output dir> -c <changelog> -p -Q -T <your api token>]

# 打包指定的 flavor
$ fir ba <project dir> [-f <flavor> -o <apk output dir> -c <changelog> -p -Q -T <your api token>]

# 打包指定的 git branch
$ fir ba <git ssh url> [-B develop -o <apk output dir> -c <changelog> -p -Q -T <your api token>]
```
