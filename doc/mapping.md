### fir mapping

`fir mapping` 指令用于将符号表上传至 [BugHD.com](http://bughd.com) 所对应的项目, 目前已经支持 dSYM 和 txt 两种格式的符号表文件上传, 有以下三种方法上传:

- 指定 version 和 build 上传:

  ```sh
  $ fir m <mapping file path> -P <bughd project id> -v <app version> -b <app build> -T <your api token>
  ```

- 在 publish 的时候自动上传:

  ```sh
  $ fir p <app file path> -m <mapping file path> -P <bughd project id> -T <your api token>
  ```
- 在 build_ipa 的时候自动上传:

  ```sh
  $ fir b <project dir> -P <bughd project id> -M -p -T <your api token>
  ```

更详细的使用说明, 可以使用 `fir mapping -h`查看相应的帮助.
