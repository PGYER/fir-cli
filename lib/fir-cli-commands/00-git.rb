# coding: utf-8
module Fir
  class Cli
    def self.git_options
      option :git, :desc => '设置 git 源'
      option :origin, :desc => '设置 git clone 的 origin'
      option :branch, :desc => '设置 git clone 的 branch'
    end
    no_commands do
      def git(path)
        arguments = '--depth 1'
        %w(origin branch).each do |_m|
          opt = method("_opt_#{_m}".to_sym).call
          arguments += " --#{_m} #{opt}" if opt
        end

        Dir.mktmpdir do |dir|
          _puts "> 克隆源代码 #{_opt_git}#{path}"
          Dir.chdir(dir) do
            _exec "git clone -q #{_opt_git}#{path} ./ #{arguments}"
            yield dir if block_given?
          end
        end
      end
    end
    private
    def _opt_git
      default = @config['git'] || 'git@github.com'
      return default if options[:git] == 'git'
      options[:git] || default
    end
  end
end
