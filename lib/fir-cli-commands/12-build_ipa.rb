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
    def _build_ipa(project_dir, *args)
      settings = {}
      vars = {}
      if args.length == 1
        args[0].each { |_k, _v| if _k.match /^[A-Z]+$/ then settings[_k] = _v else vars[_k] = _v end }
      else
        settings, vars = args[0..1]
      end

      settings = settings.select { |_k| _k != 'TARGET_BUILD_DIR' }
                         .map { |_k, _v| "#{_k}=\"#{_v}\"" }
                         .join(' ')
      arguments = '-sdk iphoneos'
      options.each do |_k, _v|
        break if !_k.start_with? 'x_'
        arguments += " -#{_k[2..-1]}" if _v
        arguments += " #{_v}" if _v.class == String
      end
      Dir.mktmpdir do |_d|
        settings += " TARGET_BUILD_DIR=#{_d}"
        Dir.chdir(project_dir) do
          _puts '> 正在清除缓存'
          _exec "xcodebuild clean 2>&1"
          _puts '> 正在编译'
          _exec "xcodebuild build #{arguments} #{settings} 2>&1"
        end
        Dir.chdir(_d) do
          ipa_path = vars[:ipa_path]
          if ipa_path
            basename = File.basename Dir['*.app'][0], '.app'
            ipa_path = File.join(ipa_path, 'build_ipa.ipa') if Dir.exist? ipa_path
            _puts '> 正在打包'
            _exec 'mkdir Payload'
            _exec 'mv *.app ./Payload'
            _exec "rm #{ipa_path}" if File.exist? ipa_path
            _exec "zip -qr #{ipa_path} Payload"
          end

          if vars[:app_path]
            _puts '> 正在复制 app 文件'
            _exec "mv ./Payload/*.app #{vars[:app_path]}"
          end
        end
        _puts '> 完成'
      end
    end
  end
end
