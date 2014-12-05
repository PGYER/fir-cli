# coding: utf-8
module Fir
  class Cli
    def self.build_ipa_options
      option :x_project, :desc => '选择编译的项目文件'
      option :x_scheme, :desc => '选择使用的 Scheme'
      option :x_target, :desc => '选择编译的 Target'
      option :x_alltarget, :desc => '编译全部 Target', :type => :boolean
      option :x_configuration, :desc => '选择编译使用的配置'
      option :output_ipa, :aliases => '-o', :desc => '指定 ipa 的输出路径'
      option :output_app, :desc => '指定 app 的输出路径'
      option :publish, :aliases => '-p', :desc => '设置是否直接发布到 FIR.im', :type => :boolean
    end
    desc 'build_ipa PATH [options] [settings]', '编译 ios app 项目，输出至 ODIR'
    build_ipa_options
    publish_options
    output_options
    def build_ipa(path, *settings)
      if _os != 'mac'
        _puts "! #{Paint['不支持在非 mac 系统上编译打包', :red]}"
        exit 1
      end
      settings = _convert_settings *settings
      ipa_path = _path options[:output_ipa] if options[:output_ipa]
      if !ipa_path
        use_tmpfile = true
        ipa_path = Tempfile.new(["#{SecureRandom.hex}", '.ipa']).path
      end
      app_path = _path options[:output_app] if options[:output_app]
      mp_path = _path options[:mobileprovision] if options[:mobileprovision]

      vars = {
        :ipa_path => ipa_path,
        :app_path => app_path
      }
      # TODO: pull from a git repo
      # if options[:git] != nil
      #   git(path) { |_d| _build_ipa _d, settings, vars }
      # else
      # end
      
      path = _path path
      project_dir = (Dir.exist? path) ? path : (File.dirname path)
      _build_ipa project_dir, settings, vars

      return if !_opt_publish
      publish ipa_path.to_s
    end

    private
    # *args 的每一个参数必须为 hash, 可以以任何顺序包含 settings, arguments, opts 的参数
    # settings 的特点是 key 全部为大写字母
    # arguments 的特点是 key 为 x_ 开头
    # 不符合 settings 及 arguments 的为 opts
    def _build_ipa(project_dir, *args)
      ignore_args = %w(:project :workspace :sdk :scheme)
      ignore_sets = %w(TARGET_BUILD_DIR)

      setstr, argstr, opts = begin
        _setstr, _argstr, _opts = ['', '-sdk iphoneos', {}]
        args.inject(&:merge).each do |_k, _v|
          _k = _k.to_s
          if _k.match /^[_A-Z0-9]$/
            next if ignore_settings.include? _k
            _setstr += " #{_k}"
            _setstr += "=#{_v}" if _v
          elsif _k.start_with? ':'
            next if ignore_args.include? _k
            _argstr += " -#{_k[1..-1]}"
            _argstr += " #{_v}" if _v.class == 'String' && !_v.empty?
          else
            _opts[_k.to_sym] = _v
          end
        end
        [_setstr, _argstr, _opts]
      end
      project = begin
        if _is_xcodeproject project_dir
          project_dir
        elsif _is_workspace project_dir
          opts[:workspace] = true
          project_dir
        elsif opts[:workspace]
          _spaces = Dir["#{project_dir}/*.xcworkspace"]
          if _spaces.length == 0
            _puts "! #{Paint['指定目录中找不到 workspace 文件，无法编译', :red]}"
            exit 1
          end
          _spaces[0]
        else
          _projs = Dir["#{project_dir}/*.xcodeproj"]
          if _projs.length == 0
            _puts "! #{Paint['指定目录中找不到 project 文件，无法编译', :red]}"
            exit 1
          else
            _projs[0]
          end
        end
      end

      Dir.mktmpdir do |_d|
        setstr += " TARGET_BUILD_DIR=#{_d} CONFIGURATION_BUILD_DIR=#{_d}"
        if opts[:workspace]
          unless opts[:scheme]
            _puts "! #{Paint['如果编译 workspace, 则必须指定一个 scheme', :red]}"
            exit 1
          end
          argstr += " -workspace \"#{project}\" -scheme \"#{opts[:scheme]}\""
        else
          argstr += " -project \"#{project}\""
        end
        puts "argstr => #{argstr}"
        puts "setstr => #{setstr}"

        # _puts '> 正在清除缓存'
        # _exec "xcodebuild clean #{argstr} 2>&1"
        _puts '> 正在编译'
        _exec "xcodebuild build #{argstr} #{setstr} 2>&1"
        Dir.chdir(_d) do
          apps = Dir['*.app']
          if opts[:ipa_path]
            ipa_path = opts[:ipa_path]
            if Dir.exist? ipa_path
              apps.each do |app|
                _ipa_path = File.join ipa_path, "#{File.basename app, '.app'}.ipa"
                _zip_ipa File.join(_d, app), _ipa_path
              end
            elsif apps.length > 1
              _puts "! #{Paint['项目编译输出了多个 app，需要指定一个已经存在的目录作为输出目录', :red]}"
              exit 1
            elsif apps.length == 0
              _puts "! #{Paint['项目编译没有输出 app，无法打包 ipa', :red]}"
              exit 1
            else
              ipa_path += '.ipa' unless ipa_path.end_with? '.ipa'
              _zip_ipa File.join(_d, apps[0]), ipa_path
            end
          end
        end
        _puts '> 完成'
      end
    end
    def _zip_ipa(app_path, ipa_path)
      Dir.mktmpdir do |_d|
        Dir.chdir(_d) do
          Dir.mkdir "Payload"
          FileUtils.cp_r app_path, 'Payload'
          if File.exist? ipa_path
            _puts "> 删除已有文件 #{ipa_path}"
            _exec "rm -r #{ipa_path}"
          end
          _puts "> 正在打包 app： #{File.basename app_path} 到 #{ipa_path}"
          _exec "zip -qr #{ipa_path} Payload"
        end
      end
    end
  end
end
