# encoding: utf-8

module FIR
  module Build

    def build_ipa *args, options
      # check build environment and make build cmd
      check_osx

      if args.first.blank? || !File.exist?(args.first)
        @build_dir = Dir.pwd
      else
        @build_dir = File.absolute_path(args.shift.to_s) # pop the first param
      end

      @build_tmp_dir = Dir.mktmpdir
      @output_path   = options[:output].blank? ? "#{@build_dir}/fir_build_ipa" : File.absolute_path(options[:output].to_s)
      @ipa_build_cmd = initialize_ipa_build_cmd(args, options)

      puts @ipa_build_cmd if $DEBUG

      logger.info "Building......"
      logger_info_dividing_line

      logger.info `#{@ipa_build_cmd}`

      output_ipa

      logger.info "Build Success"

      if options.publish?
        ipa_path = Dir["#{@output_path}/*.ipa"].first
        publish(ipa_path, short: options[:short], changelog: options[:changelog], token: options[:token])
      end
    end

    def build_apk *args, options
    end

    private

      def initialize_ipa_build_cmd args, options
        ipa_build_cmd = "xcodebuild build -sdk iphoneos"

        @configuration = options[:configuration]
        @wrapper_name  = File.basename(options[:name].to_s, '.*') + '.app' unless options[:name].blank?
        @target_name   = options[:target]
        @scheme_name   = options[:scheme]
        @dsym_name     = @wrapper_name + '.dSYM' unless @wrapper_name.blank?

        if options.workspace?
          workspace = check_and_find_ios_workspace(@build_dir)
          check_ios_scheme(@scheme_name)
          ipa_build_cmd += " -workspace '#{workspace}' -scheme '#{@scheme_name}'"
        else
          project = check_and_find_ios_project(@build_dir)
          ipa_build_cmd += " -project '#{project}'"
        end

        ipa_build_cmd += " -configuration '#{@configuration}'" unless @configuration.blank?
        ipa_build_cmd += " -target '#{@target_name}'" unless @target_name.blank?
        ipa_build_cmd += " #{ipa_custom_settings(args)} 2>&1"

        ipa_build_cmd
      end

      def ipa_custom_settings args
        custom_settings = parse_ipa_custom_settings(args)

        # convert { "a" => "1", "b" => "2" } => "a='1' b='2'"
        setting_str =  custom_settings.collect { |k, v| "#{k}='#{v}'" }.join(' ')
        setting_str += " WRAPPER_NAME='#{@wrapper_name}'" unless @wrapper_name.blank?
        setting_str += " TARGET_BUILD_DIR='#{@build_tmp_dir}'" unless custom_settings['TARGET_BUILD_DIR']
        setting_str += " CONFIGURATION_BUILD_DIR='#{@build_tmp_dir}'" unless custom_settings['CONFIGURATION_BUILD_DIR']
        setting_str += " DWARF_DSYM_FOLDER_PATH='#{@output_path}'" unless custom_settings['DWARF_DSYM_FOLDER_PATH']
        setting_str += " DWARF_DSYM_FILE_NAME='#{@dsym_name}'" unless @dsym_name.blank?
        setting_str
      end

      def output_ipa
        FileUtils.mkdir_p(@output_path) unless File.exist?(@output_path)
        Dir.chdir(@build_tmp_dir) do
          apps = Dir["*.app"]
          if apps.length == 0
            logger.error "Builded has no output app, Can not be packaged"
            exit 1
          end

          apps.each do |app|
            ipa_path = File.join(@output_path, "#{File.basename(app, '.app')}.ipa")
            zip_app2ipa(File.join(@build_tmp_dir, app), ipa_path)
          end
        end
      end

      # convert ['a=1', 'b=2'] => { 'a' => '1', 'b' => '2' }
      def parse_ipa_custom_settings args
        hash = {}
        args.each do |setting|
          k, v = setting.split('=', 2).map(&:strip)
          hash[k] = v
        end

        hash
      end

      def check_osx
        unless OS.mac?
          logger.error "Unsupported OS type, `build_ipa` only support for OSX"
          exit 1
        end
      end

      def check_and_find_ios_project path
        unless File.exist?(path)
          logger.error "The first param BUILD_DIR must be a xcodeproj directory"
          exit 1
        end

        if is_ios_project?(path)
          project = path
        else
          project = Dir["#{path}/*.xcodeproj"].first
          if project.blank?
            logger.error "The xcodeproj file is missing, check the BUILD_DIR"
            exit 1
          end
        end

        project
      end

      def check_and_find_ios_workspace path
        unless File.exist?(path)
          logger.error "The first param BUILD_DIR must be a xcworkspace directory"
          exit 1
        end

        if is_ios_workspace?(path)
          workspace = path
        else
          workspace = Dir["#{path}/*.xcworkspace"].first
          if workspace.blank?
            logger.error "The xcworkspace file is missing, check the BUILD_DIR"
            exit 1
          end
        end

        workspace
      end

      def check_ios_scheme scheme_name
        if scheme_name.blank?
          logger.error "Must provide a scheme by `-S` option when build a workspace"
          exit 1
        end
      end

      def is_ios_project? path
        File.extname(path) == '.xcodeproj'
      end

      def is_ios_workspace? path
        File.extname(path) == '.xcworkspace'
      end

      def zip_app2ipa app_path, ipa_path
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir) do
            Dir.mkdir("Payload")
            FileUtils.cp_r(app_path, "Payload")
            system("rm -rf #{ipa_path}") if File.file? ipa_path
            system("zip -qr #{ipa_path} Payload")
          end
        end
      end

  end
end
