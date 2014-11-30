# coding: utf-8
module Fir
  class Cli
    desc 'config', '配置全局设置'
    option :token, :aliases => '-t', :desc => '用户 token'
    option :email, :aliases => '-e', :desc => '邮件地址'
    option :resign, :aliases => '-r', :desc => '是否以企业签名发布 ios 应用', :type => :boolean
    output_options
    def config
      if options.length > 0
        options.each do |option|
          _puts "> #{Paint[option[0].to_s.rjust(10), :blue]} : #{@config[option[0].to_s]} => #{option[1]}"
          @config[option[0].to_s] = option[1]
        end
        if @config['token'] && !_user(@config['token'])
          _puts_invalid_token
          exit 1
        end
        @config.save
      end
      _puts '> 设置完成，您现在使用的设置是'
      @config.save 
      @config.each { |conf| _puts "> #{Paint[conf[0].to_s.rjust(10), :blue]} => #{conf[1]}"}
    end
  end
end
