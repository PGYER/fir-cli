require 'uri'
require 'json'
require 'pathname'
require 'tempfile'
require 'securerandom'

require 'thor'
require 'paint'
require 'pngdefry'
require 'user_config'
require 'rest_client'
require 'lagunitas'
require 'ruby_apk'

module Fir
  class Cli < Thor
    def initialize(*args)
      super
      _init_config
      _puts_welcome
    end
    def self.load_extends
      `gem list --local`.each_line("\n") do |gem|
        gem_name = /^[^\s]+/.match(gem)[0]
        require gem_name if gem_name.start_with? 'fir-cli-'
      end
    end
  	private
    def _init_config
      @uconfig = UserConfig.new '.fir'
      @config = @uconfig['default.yaml']
      @tmpfiles = []
    end
    def _path(path)
      path = Pathname.new(Dir.pwd).join(path).cleanpath
    end
    def _opt_token
      @token ||= options[:token] || @config['token']
    end
    def _opt_email
      @email ||= options[:email] || @config['email']
    end
    def _opt_verbose
      @verbose ||= options[:verbose] || @config['verbose']
    end
    def _opt_resign
      return options[:resign] if defined? options[:resign]
      @resign ||= options[:resign] || @config['resign']
    end
    def _opt_quiet
      return options[:quiet] if defined? options[:quiet]
      @quiet ||= options[:quiet] || @config['quiet']
    end
    def _is_ipa(path)
      path.end_with? '.ipa'
    end
    def _is_apk(path)
      path.end_with? '.apk'
    end
    def _is_identifier(str)
      /^(?:(?:[a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*(?:[A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$/.match str
    end
    def _chk_login
      if !_opt_token
        _puts "! #{ Paint['您还没有登录, 请输入:', :red] } fir login USER_TOKEN #{ Paint['进行登录', :red] }"
        exit 1
      end
    end
    def _puts_welcome
      _puts "> #{ Paint['欢迎使用 FIR.im 命令行工具，如需帮助请输入:', :green] } fir help"
    end
    def _puts(text)
      return if _opt_quiet
      case _opt_verbose || 'vv' # If nothing about log is set, use the default option - vv
      when 'v'
        puts text if text.start_with?('!')
      when 'vv'
        puts text if text.start_with?('!') || text.start_with?('>')
      when 'vvv'
        puts text if text.start_with?('!') || text.start_with?('>') || text.start_with?('-')
      end
    end
    def _info(path, more = false)
      if _is_ipa path
        _ipa_info path, more
      elsif _is_apk path
        _apk_info path, more
      else
        _puts "! #{ Paint['只能支持后缀为 ipa 和 apk 地文件', :red] }"
      end
    end
    def _apk_info(path, more = false)
      path = _path path
      apk = Android::Apk.new path
      info = {
        :type => 'android',
        :identifier => apk.manifest.package_name,
        :name => apk.label,
        :version => apk.manifest.version_code,
        :short_version => apk.manifest.version_name
      }
      if more
        info[:icons] = apk.icon.map do |name, data|
          tfile = Tempfile.new ["icon-#{ SecureRandom.hex }", '.png']
          tfile.write data
          @tmpfiles.push tfile
          {
            :name => File.basename(name),
            :path => tfile.path
          }
        end
      end
      info
    end
    def _ipa_info(path, more = false)
      path = _path path
      ipa = Lagunitas::IPA.new path
      _puts '> 正在解析 ipa 文件...'
      app = ipa.app
      info = {
        :type => 'ios',
        :identifier => app.identifier,
        :name => app.name,
        :display_name => app.display_name,
        :version => app.version,
        :short_version => app.short_version,
        :devices => app.devices,
        :release_type => app.release_type,
        :distribution_name => app.distribution_name
      }
      if more
        if app.icons
          info[:icons] = app.icons.map do |icon|
            tfile = Tempfile.new ["icon-#{ SecureRandom.hex }", '.png']
            @tmpfiles.push tfile
            FileUtils.cp icon[:path], tfile.path
            {
              :name => File.basename(icon[:path]),
              :path => tfile.path
            }
          end
        end
        info[:plist] = app.info
        app.mobileprovision.delete 'DeveloperCertificates' if app.mobileprovision
        info[:mobileprovision] = app.mobileprovision
      end
      ipa.cleanup
      info
    end
    def _fir_info(identifier, type = 'ios')
      _puts "> 正在获取 #{ identifier }@FIR.im 的应用信息..."
      _chk_login
      body = { :token => @token, :type => type }
      res = RestClient.get "http://fir.im/api/v2/app/info/#{ identifier }?#{ URI.encode_www_form body }"
      JSON.parse res.body, :symbolize_names => true
    end
    def _fir_put(id, body)
      _chk_login
      body[:token] = @token
      _puts '> 正在更新 fir 的应用信息...'
      RestClient.put "http://fir.im/api/v2/app/#{ id }?#{ URI.encode_www_form body }", body
      _puts '> 更新成功'
    end
    def _fir_vput(id, body)
      _chk_login
      body[:token] = @token
      _puts '> 正在更新 fir 的应用版本信息...'
      RestClient.put "http://fir.im/api/v2/appVersion/#{ id }/complete?#{ URI.encode_www_form body }", body
      _puts '> 更新成功'
    end
  end
end
