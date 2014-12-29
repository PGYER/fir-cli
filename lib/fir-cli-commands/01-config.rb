# coding: utf-8
module Fir
  class Cli
    desc 'config', '配置全局设置'
    option :token, :aliases => '-t', :desc => '用户 token'
    option :email, :aliases => '-e', :desc => '邮件地址'
    option :resign, :aliases => '-r', :desc => '是否以企业签名发布 ios 应用', :type => :boolean
    option :private_key, :desc => '私密通道'
    option :publish, :aliases => '-p', :desc => '编译打包自动发布至 FIR.im', :type => :boolean
    output_options
    def config(*args)
      _set_config options.merge _convert_settings *args
      _puts '> 设置完成，您现在使用的设置是'
      @config.each { |conf| _puts "> #{Paint[conf[0].to_s.rjust(10), :blue]} => #{conf[1]}" }
    end
  end
end
