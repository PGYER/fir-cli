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
  - (2.0.16) 更新了 thor
  - (2.0.15) 修改了API域名
  - (2.0.14) 第三方通知加入了 app 类型, 第三方报错将不再直接报出异常
  - (2.0.13) 修复了无法跳过企业微信通知逻辑的bug
  - (2.0.12) 修复因为钉钉机器人不再支持base64导致无法显示二维码，另外开始支持钉钉加签方式的鉴权， 参数为 --dingtalk_secret
  - (2.0.11) 兼容了 ruby 3.0 版本, 增加了环境变量FEISHU_TIMEOUT，可以多给飞书一些超时时间
  - (2.0.10) 飞书支持了 V2 版本的机器人推送
  - (2.0.9) publish 支持了 企业微信通知 可以使用 --wxwork_access_token 或 --wxwork_webhook, 增加了回调超时时间至20秒
  - (2.0.8) publish 支持 飞书通知, 可使用 `feishu_access_token` 和 `feishu_custom_message`, 详情见 `fir publish --help`
  - (2.0.7) 修复了提示 token 有问题的错误
  - [fir-cli](https://github.com/firhq/fir-cli) 已经开源
  - 欢迎 fork, issue 和 pull request
  )

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  # spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest', '~> 5.7'
  spec.add_development_dependency 'pry',      '~> 0.10'

  spec.add_dependency 'admqr_knife',    '~> 0.1.5'
  spec.add_dependency 'thor',           '~> 1.2.1'
  spec.add_dependency 'rest-client',    '~> 2.0'
  spec.add_dependency 'ruby_android_apk',   '~> 0.7.7.1'
  spec.add_dependency 'rqrcode',        '~> 0.7'
  spec.add_dependency 'rexml'
  spec.add_dependency 'CFPropertyList'
  spec.add_dependency 'api_tools', '~> 0.1.1'
end
