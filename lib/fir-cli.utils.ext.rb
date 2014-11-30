module Fir
  class Cli
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
    def self.output_options
      option :verbose,
             :desc => '设置输出辅助信息的详细程度: v, vv, vvv',
             :type => :string,
             :enum => ['v', 'vv', 'vvv']
      option :quiet,
             :aliases => '-q',
             :desc => '安静模式，不输出任何辅助信息',
             :type => 'boolean'
      option :color,
             :desc => '设置输出带有颜色的信息',
             :type => 'boolean'
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
    %w(token, email, verbose).each do |_m|
      define_method "_opt_#{_m}" do
        unless instance_variable_get("@#{_m}")
          instance_variable_set("@#{_m}", options[_m.to_sym] || @config[_m] )
        end
        instance_variable_get("@#{_m}")
      end
    end
    %w(resign quiet color trim).each do |_m|
      define_method "_opt_#{_m}" do
        return false if options[_m.to_sym] == false
        unless instance_variable_get("@#{_m}")
          instance_variable_set("@#{_m}", options[_m.to_sym] || @config[_m] )
        end
        instance_variable_get("@#{_m}")
      end
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
      ask(prompt) { |q| q.echo = false }
    end
    def _prompt(prompt)
      ask(prompt) { |q| q }
    end
    def _puts(text)
      return puts _format text if !/^[->!] /.match text
      return if _opt_quiet
      case _opt_verbose || 'vv' # If nothing about log is set, use the default option - vv
      when 'v'
        puts _format text if text.start_with?('!')
      when 'vv'
        puts _format text if text.start_with?('!') || text.start_with?('>')
      when 'vvv'
        puts _format text if text.start_with?('!') || text.start_with?('>') || text.start_with?('-')
      end
    end
    def _format(text)
      return text.gsub /\e\[\d+(?:;\d+)*m/, '' if _opt_color == false
      text
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
