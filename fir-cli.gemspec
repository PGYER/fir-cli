# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fir/version'

Gem::Specification.new do |spec|
  spec.name          = 'fir-cli'
  spec.version       = FIR::VERSION
  spec.authors       = ['NaixSpirit', 'atpking']
  spec.email         = ['atpking@gmail.com']
  spec.date          = Time.now.strftime('%Y-%m-%d')
  spec.summary       = 'fir.im command tool'
  spec.description   = 'fir.im command tool, support iOS and Android'
  spec.homepage      = 'https://github.com/FIRHQ/fir-cli'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.post_install_message = %q(
        ______________        ________    ____
       / ____/  _/ __ \      / ____/ /   /  _/
      / /_   / // /_/ /_____/ /   / /    / /
     / __/ _/ // _, _/_____/ /___/ /____/ /
    /_/   /___/_/ |_|      \____/_____/___/

  ## 更新记录
  - (1.7.2) 修正了无论是否加参数都固定出现二维码图片的bug
  - (1.7.1) 增加了 钉钉推送 , 增加了返回指定版本下载地址
  - (1.7.0) 过期了ipa_build 功能, 增加了对 android manifest instant run 的兼容
  - (1.6.13) 上传图标逻辑修改
  - (1.6.12) 修复了部分机器没有默认安装 byebug 的问题
  - (1.6.11) 变化了 ruby gem 仓库地址
  - [fir-cli](https://github.com/firhq/fir-cli) 已经开源
  - 欢迎 fork, issue 和 pull request
  )

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.7'
  spec.add_development_dependency 'pry',      '~> 0.10'

  spec.add_dependency 'thor',           '~> 0.19'
  spec.add_dependency 'rest-client',    '~> 2.0'
  spec.add_dependency 'ruby_android',   '~> 0.7.7'
  spec.add_dependency 'rqrcode',        '~> 0.7'
  spec.add_dependency 'CFPropertyList'
  spec.add_dependency 'api_tools', '~> 0.1.0'
end
