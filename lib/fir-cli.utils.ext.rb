module Fir
  class Cli < Thor
    def initialize(*args)
      super
      _init_config
      _puts_welcome
    end
    def self.find_extends
      `gem list --local`
        .each_line("\n")
        .map { |gem| /^[^\s]+/.match(gem)[0] }
        .select { |gem| true if gem.start_with? 'fir-cli-' }
    end
    private
    def _extends
      @extends ||= Cli.find_extends
    end
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
    def _is_email(str)
      /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/i.match str
    end
    def _chk_login(prompt = true)
      if !_opt_token && prompt == true
        token = _prompt_secret('请输入用户 token：')
        @token = token if token.length > 0
      end
      if !@token
        _puts_require_token
        exit 1
      elsif !_user(@token)
        _puts_invalid_token
        exit 1
      end
    end
    def _prompt_secret(prompt)
      ask(prompt { |q| q.echo = false })
    end
    def _prompt(prompt)
      ask(prompt { |q| q })
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
    def _puts_welcome
      _puts "> #{Paint['欢迎使用 FIR.im 命令行工具，如需帮助请输入:', :green]} fir help"
    end
    def _puts_require_token
      _puts "! #{Paint['用户 token 不能为空', :red]}"
    end
    def _puts_invalid_token
      _puts "! #{Paint['输入的用户 token 不合法', :red]}"
    end
    def _puts_invalid_email
      _puts "! #{Paint['输入的邮件地址不合法', :red]}"
    end
    def _info(path, more = false)
      if _is_ipa path
        _ipa_info path, more
      elsif _is_apk path
        _apk_info path, more
      else
        _puts "! #{Paint['只能支持后缀为 ipa 和 apk 的文件', :red]}"
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
          tfile = Tempfile.new ["icon-#{SecureRandom.hex}", '.png']
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
            tfile = Tempfile.new ["icon-#{SecureRandom.hex}", '.png']
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
  end
end
