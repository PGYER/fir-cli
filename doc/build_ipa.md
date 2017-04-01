### fir build_ipa

`fir build_ipa` 对 `xcodebuild` 原生指令进行了封装, 将常用的参数名简化, 支持全部的自带参数及设置, 同时输出符号表 dSYM 文件, 并且支持直接从 Github/Gitlab 相关 repo 直接编译打包.

```sh
$ fir build_ipa --help
fir build_ipa --help
Usage:
  fir build_ipa BUILD_DIR [options] [settings]

Options:
  -B, [--branch=BRANCH]                # Set branch if project is a git repo, the default is `master`
  -w, [--workspace], [--no-workspace]  # true/false if build workspace
  -S, [--scheme=SCHEME]                # Set the scheme NAME if build workspace
  -C, [--configuration=CONFIGURATION]  # Use the build configuration NAME for building each target
  -d, [--destination=DESTINATION]      # Set the destinationspecifier
  -t, [--target=TARGET]                # Build the target specified by targetname
  -E, [--export_method=METHOD]         # for exportOptionsPlist method, ad-hoc as default
  -O, [--optionPlistPath]              # User defined exportOptionsPlist path
  -f, [--profile=PROFILE]              # Set the export provisioning profile
  -o, [--output=OUTPUT]                # IPA output path, the default is: BUILD_DIR/fir_build_ipa
  -p, [--publish], [--no-publish]      # true/false if publish to fir.im
  -s, [--short=SHORT]                  # Set custom short link if publish to fir.im
  -n, [--name=NAME]                    # Set custom ipa name when builded
  -c, [--changelog=CHANGELOG]          # Set changelog if publish to fir.im
  -Q, [--qrcode], [--no-qrcode]        # Generate qrcode
  -M, [--mapping], [--no-mapping]      # true/false if upload app mapping file to BugHD.com
  -P, [--proj=PROJ]                    # Project id in BugHD.com if upload app mapping file
      [--open], [--no-open]            # true/false if open for everyone, the default is: true
                                       # Default: true
      [--password=PASSWORD]            # Set password for app
  -T, [--token=TOKEN]                  # User's API Token at fir.im
  -L, [--logfile=LOGFILE]              # Path to writable logfile
  -V, [--verbose], [--no-verbose]      # Show verbose
                                       # Default: true
  -q, [--quiet], [--no-quiet]          # Silence commands
  -h, [--help], [--no-help]            # Show this help message and quit
```

示例:

- 编译 project, 加上 changelog, 并发布到 fir.im 上并生成二维码图片

  ```
  $ fir build_ipa path/to/project -o path/to/output -p -c "this is changelog" -Q -T YOUR_API_TOKEN
  ```

- 编译 Github 上的 workspace

  ```sh
  $ fir build_ipa git@github.com:xxxx.git -o path/to/output -w -C Release -t allTargets GCC_PREPROCESSOR_DEFINITIONS="FOO=bar"
  ```
  该指令在指向的目录中，找到第一个 workspace 文件, 对其进行编译. 使用 `Release` 设置，编译策略为 `allTargets`, 同时设置了预编译参数 `FOO`.

- 编译用 CocoaPods 做依赖管理的 .ipa 包

  ```sh
  $ fir build_ipa path/to/workspace -w -S <scheme name>
  ```


ChangeLog 1.6.0

- 支持 XCode 8.3 打包      
 * 新增参数 -E，指定 exportOptionsPlist plist 文件中的方法, 默认为 ad-hoc
 * 用户可自定义 -exportOptionsPlist 中的 plist 路径