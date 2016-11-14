### fir info

`fir info` 命令用于查看当前 ipa/apk 相关信息.

```sh
$ fir info --help
Usage:
  fir info APP_FILE_PATH

Show iOS/Android app info, support ipa/apk file (aliases: `i`).
```

#### 查看 ipa 相关信息

```sh
$ fir info ./build_ipa.ipa

I, [2016-03-08T12:28:29.310846 #11961]  INFO -- : Analyzing ipa file......
I, [2016-03-08T12:28:29.310932 #11961]  INFO -- : ✈ -------------------------------------------- ✈
I, [2016-03-08T12:28:29.395706 #11961]  INFO -- : type: ios
I, [2016-03-08T12:28:29.395775 #11961]  INFO -- : identifier: xx.xxx.build-ipa
I, [2016-03-08T12:28:29.395793 #11961]  INFO -- : name: build_ipa
I, [2016-03-08T12:28:29.395805 #11961]  INFO -- : display_name: build_ipa
I, [2016-03-08T12:28:29.395817 #11961]  INFO -- : build: 1
I, [2016-03-08T12:28:29.395829 #11961]  INFO -- : version: 1.0
I, [2016-03-08T12:28:29.396007 #11961]  INFO -- : devices: ["fasdfafaf3f4xxxxxxx78aecbc1234567"]
I, [2016-03-08T12:28:29.396057 #11961]  INFO -- : release_type: adhoc
I, [2016-03-08T12:28:29.396086 #11961]  INFO -- : distribution_name: iOSTeam Provisioning Profile: xx.xxx.* - xxx xx xxxxxx LLC.
I, [2016-03-08T12:28:29.396111 #11961]  INFO -- :
```

#### 查看 apk 相关信息

```sh
$ fir info ./test_apk.apk
I, [2016-03-08T12:30:25.241278 #12073]  INFO -- : Analyzing apk file......
I, [2016-03-08T12:30:25.241363 #12073]  INFO -- : ✈ -------------------------------------------- ✈
I, [2016-03-08T12:30:25.250430 #12073]  INFO -- : type: android
I, [2016-03-08T12:30:25.250477 #12073]  INFO -- : identifier: com.xxx.myapplication
I, [2016-03-08T12:30:25.250496 #12073]  INFO -- : name: My Application
I, [2016-03-08T12:30:25.250509 #12073]  INFO -- : build: 1
I, [2016-03-08T12:30:25.250520 #12073]  INFO -- : version: 1.0
I, [2016-03-08T12:30:25.250532 #12073]  INFO -- :
```
