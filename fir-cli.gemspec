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
  - (1.6.13) 上传图标逻辑修改
  - (1.6.12) 修复了部分机器没有默认安装 byebug 的问题
  - (1.6.11) 变化了 ruby gem 仓库地址
  - (1.6.10) 增加显示release_id 以及 app_id
  - (1.6.9) 取消了依赖 cfpropertylist 的具体版本号
  - (1.6.8) 取消了远端回调, 改为本地callback
  - (1.6.8) fir-cli 也支持了私有部署模式
  - [fir-cli](https://github.com/firhq/fir-cli) 已经开源
  - 欢迎 fork, issue 和 pull request
  )

  spec.add_development_dependency 'bundler',  '~> 1.7'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.7'
  spec.add_development_dependency 'pry',      '~> 0.10'

  spec.add_dependency 'thor',           '~> 0.19'
  spec.add_dependency 'rest-client',    '~> 2.0'
  spec.add_dependency 'ruby_android',   '~> 0.7.7'
  spec.add_dependency 'rqrcode',        '~> 0.7'
  spec.add_dependency 'CFPropertyList'
  spec.add_dependency 'api_tools'
  spec.add_dependency 'byebug'
  spec.add_dependency 'xcodeproj'
end
