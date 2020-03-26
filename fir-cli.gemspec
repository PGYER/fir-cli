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
  - (2.0.9) publish 支持了 企业微信通知 可以使用 --wxwork_access_token 或 --wxwork_webhook, 增加了回调超时时间至20秒
  - (2.0.8) publish 支持 飞书通知, 可使用 `feishu_access_token` 和 `feishu_custom_message`, 详情见 `fir publish --help`
  - (2.0.7) 修复了提示 token 有问题的错误
  - (2.0.6) 将校验文件是否存在提前
  - (2.0.5) 更换了上传域名, 避免与 深信服的设备冲突
  - (2.0.4) 修复了 cdn 不支持 patch 方法透传, 导致在修改 app 信息的时候返回的 400 错误
  - (2.0.3) 增加 dingtalk_at_phones, 钉钉通知可 at 用户手机号, 以逗号,分割.  此命令需配合 `dingtalk_access_token` 使用
  - (2.0.3) 增加 dingtalk_at_all, 钉钉通知可 at 所有人, 此命令需配合 `dingtalk_access_token` 使用
  - (2.0.3) publish 增加海外加速参数 --oversea_turbo
  - (2.0.2) 有限支持 aab 文件上传, 强依赖`bundletool`工具, 具体请参见参数 `--bundletool_jar_path` 和 `auto_download_bundletool_jar`
  - (2.0.1) publish 支持 新参数 `specify_app_display_name`, 指定 app 显示名称
  - (2.0.1) publish 支持 新参数 `need_ansi_qrcode`, 在控制台直接打印二维码, jenkins 用户可能需要使用 `AnsiColor Plugin` 插件配合
  - (2.0.1) publish 支持 新参数 `dingtalk_custom_message`, 可以在钉钉通知里增加自定义消息, 此命令需配合 `dingtalk_access_token` 使用
  - (2.0.1) publish 支持 新参数 `skip_fir_cli_feedback`, 可禁止 fir-cli 发送统计信息
  - (2.0.0) publish 使用更快的存储商, 加速上传速度, 若感觉没以前可使用 switch_to_qiniu 恢复
  - [fir-cli](https://github.com/firhq/fir-cli) 已经开源
  - 欢迎 fork, issue 和 pull request
  )

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  # spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest', '~> 5.7'
  spec.add_development_dependency 'pry',      '~> 0.10'
  
  spec.add_dependency 'admqr_knife',    '~> 0.1.5'
  spec.add_dependency 'thor',           '~> 0.19'
  spec.add_dependency 'rest-client',    '~> 2.0'
  spec.add_dependency 'ruby_android_apk',   '~> 0.7.7.1'
  spec.add_dependency 'rqrcode',        '~> 0.7'
  spec.add_dependency 'CFPropertyList'
  spec.add_dependency 'api_tools', '~> 0.1.0'
end
