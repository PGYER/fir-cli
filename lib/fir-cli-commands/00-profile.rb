# coding: utf-8
module Fir
  class Cli
    desc 'profile', '切换配置文件'
    option :delete, :aliases => '-d', :desc => '删除指定的配置文件', :type => :boolean
    output_options
    def profile(prof)
      if prof == 'global'
        _puts '! 不能使用 global 作为配置文件名'
        _exit
      end
      prof = "#{prof}.yaml"
      if options[:delete]
        _puts "> 正在删除配置文件：#{prof}"
        @uconfig.delete prof
      else
        if _profile == prof
          _puts "! #{Paint["你正在使用该配置：#{prof}", :red]}"
          _exit
        end
        _puts "> 正在使用配置文件：#{_profile}"
        _puts "> 即将替换为：#{prof}"
        @global_config['profile'] = prof
        @global_config.save
        _load_config
        _puts "> 已替换为：#{prof}"
        config
      end
    end
  end
end
