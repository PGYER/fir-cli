# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fir/version'

Gem::Specification.new do |spec|
  spec.name          = "fir-cli"
  spec.version       = FIR::VERSION
  spec.authors       = ["FIR.im"]
  spec.email         = ["dev@fir.im"]
  spec.date          = Time.now.strftime("%Y-%m-%d")
  spec.summary       = %q{FIR.im command tool}
  spec.description   = %q{FIR.im command tool, support iOS and Android}
  spec.homepage      = "http://blog.fir.im/2014/fir_cli"
  spec.license       = "GPLv3"

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
  ### FIR-CLI 1.0
  - 重大重构
  - 优化启动及运行速度
  - 增加各指令的 alias
  - 增加全局参数, -T, -L, -V, -q, -h, 分别为 token, log, verbose, quite, help 参数
  - 增加输出 log
  - 修正部分系统安装失败问题
  - 修正部分服务器安装出现编码失败问题
  - 修正 ipa 路径带有空格解析失败的 bug
  - 重写 ipa 解析器, 去除 `miniz.c`, 增加 pngcrash
  - 上传 ipa 时, 优先取 `display_name` 作为应用名称
  - build_ipa 增加默认 build 路径, `fir b` 则默认 build 当前路径
  - build_ipa 增加输出 dSYM 符号表文件
  - build_ipa 增加输出 xcodebuild 的信息
  - 去掉输出信息颜色, 方便查看 log
  - 简化 --verbose 参数, 简化为 `--verbose --no-verbose`, 默认输出为 INFO
  )

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.11"

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "CFPropertyList", "~> 2.3"
  spec.add_dependency "rest-client", "~> 1.7"
  spec.add_dependency "ruby_android", "~> 0.7"
end
