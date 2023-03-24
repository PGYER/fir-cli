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

  ##
  - [fir-cli](https://github.com/firhq/fir-cli) 已经开源
  - 欢迎 fork, issue 和 pull request
  - 同时提供 go 版本的 fir-cli 二进制版本无依赖  [fir-cli-go](https://github.com/PGYER/go-fir-cli/releases)
  )

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  # spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest', '~> 5.7'
  spec.add_development_dependency 'pry',      '~> 0.10'

  spec.add_dependency 'admqr_knife',    '~> 0.2.0'
  spec.add_dependency 'thor',           '~> 1.2.1'
  spec.add_dependency 'rest-client',    '~> 2.0'
  spec.add_dependency 'ruby_android_apk',   '~> 0.7.7.1'
  spec.add_dependency 'rqrcode',        '~> 0.7'
  spec.add_dependency 'rexml'
  spec.add_dependency 'CFPropertyList'
  spec.add_dependency 'api_tools', '~> 0.1.1'
end
