# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fir/version'

Gem::Specification.new do |spec|
  spec.name          = "fir-cli"
  spec.version       = FIR::VERSION
  spec.authors       = ["FIR.im", "NaixSpirit"]
  spec.email         = ["dev@fir.im"]
  spec.date          = Time.now.strftime("%Y-%m-%d")
  spec.summary       = %q{FIR.im command tool}
  spec.description   = %q{FIR.im command tool, support iOS and Android}
  spec.homepage      = "http://blog.fir.im/fir_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message = %q(
        ______________        ________    ____
       / ____/  _/ __ \      / ____/ /   /  _/
      / /_   / // /_/ /_____/ /   / /    / /
     / __/ _/ // _, _/_____/ /___/ /____/ /
    /_/   /___/_/ |_|      \____/_____/___/

  ## 更新记录
  ### FIR-CLI 1.1.8
  - 完全兼容新版 API ✔
  - 请使用新版 API Token
  - 新版 API Token 查看地址: `http://fir.im/user/info`
  - 增加符号表上传指令, `fir mapping(alias m)`
  - 有以下三种方式上传符号表(目前已经支持 dSYM 和 txt 两种格式的符号表文件上传)
    - 1. 指定 version 和 build 上传: `fir m <mapping file path> -P <bughd project id> -v <app version> -b <app build> -T <your api token>`
    - 2. 在 publish 的时候自动上传: `fir p <app file path> -m <mapping file path> -P <bughd project id> -T <your api token>`
    - 3. 在 build_ipa 的时候自动上传: `fir b <project dir> -P <bughd project id> -M -p -T <your api token>`
  - 支持 gradle 打包 apk 文件并自动上传至 fir.im, `fir build_apk(alias ba)`
    - `fir ba <project dir> [-o <apk output dir> -c <changelog> -p -T <your api token>]`
  - https://github.com/FIRHQ/fir-cli
  )

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7"
  spec.add_development_dependency "pry", "~> 0.10"

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "CFPropertyList", "~> 2.3"
  spec.add_dependency "rest-client", "~> 1.7"
  spec.add_dependency "ruby_android", "~> 0.7"
end
