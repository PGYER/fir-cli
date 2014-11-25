module Fir
  class Cli < Thor
    desc 'config', '配置全局设置'
    option :token, :aliases => '-t', :desc => '用户令牌'
    option :email, :aliases => '-e', :desc => '邮件地址'
    option :resign, :aliases => '-r', :desc => '是否以企业签名发布 ios 应用', :type => :boolean
    option :verbose, :aliases => '-v', :desc => '输出级别项 v, vv, vvv', :type => :string, :enum => ['v', 'vv', 'vvv']
    option :quiet, :aliases => '-q', :desc => '安静模式', :type => :boolean
    def config
      if options.length > 0
        options.each do |conf|
          puts "> #{ Paint[conf[0].to_s.rjust(10), :blue] } : #{ @config[conf[0].to_s] } => #{ conf[1] }"
          @config[conf[0]] = conf[1]
        end
        @config.save
      end
      puts '> 当前设置：'
      @config.each {|conf| puts "> #{ Paint[conf[0].to_s.rjust(10), :blue] } => #{ conf[1] }"}
    end
  end
end
