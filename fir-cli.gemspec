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
  - publish 指令增加 -r 参数, 会返回 release_id 信息 
  - 推荐用户使用 fastlane gym build ipa文件 
  - [fir-cli](https://github.com/FIRHQ/fir-cli) 已经开源
  - 欢迎 fork, issue 和 pull request
  )

  spec.add_development_dependency 'bundler',  '~> 1.7'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.7'
  spec.add_development_dependency 'pry',      '~> 0.10'

  spec.add_dependency 'thor',           '~> 0.19'
  spec.add_dependency 'CFPropertyList', '~> 2.3'
  spec.add_dependency 'rest-client',    '~> 2.0'
  spec.add_dependency 'ruby_android',   '~> 0.7.7'
  spec.add_dependency 'rqrcode',        '~> 0.7'
  spec.add_dependency 'api_tools'       
  spec.add_dependency 'xcodeproj'
end
