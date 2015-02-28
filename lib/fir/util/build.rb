# encoding: utf-8

module FIR
  module Build

    def build_ipa *args, options
      # initialize build options
      if File.exist?(args.first)
        build_dir = File.absolute_path(args.shift.to_s) # pop the first param
      else
        build_dir = Dir.pwd
      end

      build_cmd       = "xcodebuild build -sdk iphoneos"
      build_tmp_dir   = Dir.mktmpdir
      custom_settings = parse_custom_settings(args)         # ['a=1', 'b=2'] => { 'a' => '1', 'b' => '2' }
      configuration   = options[:configuration]
      target_name     = options[:target]
      scheme_name     = options[:scheme]
      output_path     = options[:output].blank? ? "#{build_dir}/build_ipa" : File.absolute_path(options[:output].to_s)

      # check build environment and make build cmd
      check_osx
      if options.workspace?
        workspace = check_and_find_workspace(build_dir)
        check_scheme(scheme_name)
        build_cmd += " -workspace '#{workspace}' -scheme '#{scheme_name}'"
      else
        project = check_and_find_project(build_dir)
        build_cmd += " -project '#{project}'"
      end

      build_cmd += " -configuration '#{configuration}'" unless configuration.blank?
      build_cmd += " -target '#{target_name}'" unless target_name.blank?

      custom_settings.delete('TARGET_BUILD_DIR')
      custom_settings.delete('CONFIGURATION_BUILD_DIR')
      setting_str = custom_settings.collect { |k, v| "#{k}='#{v}'" }.join(' ') # { "a" => "1", "b" => "2" } => "a='1' b='2'"
      setting_str += " TARGET_BUILD_DIR='#{build_tmp_dir}' CONFIGURATION_BUILD_DIR='#{build_tmp_dir}'"
      setting_str += " DWARF_DSYM_FOLDER_PATH='#{output_path}'"

      build_cmd += " #{setting_str} 2>&1"
      puts build_cmd if $DEBUG

      logger.info "Building......"
      logger_info_dividing_line

      system(build_cmd)

      FileUtils.mkdir_p(output_path) unless File.exist?(output_path)
      Dir.chdir(build_tmp_dir) do
        apps = Dir["*.app"]
        if apps.length == 0
          logger.error "Builded has no output app, Can not be packaged"
          exit 1
        end

        apps.each do |app|
          ipa_path = File.join(output_path, "#{File.basename(app, '.app')}.ipa")
          zip_app2ipa(File.join(build_tmp_dir, app), ipa_path)
        end
      end

      logger.info "Build Success"

      if options.publish?
        ipa_path = Dir["#{output_path}/*.ipa"].first
        publish(ipa_path, short: options[:short], changelog: options[:changelog], token: options[:token])
      end
    end

    def build_apk *args, options
    end

    private

      def parse_custom_settings args
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

      def check_and_find_project path
        unless File.exist?(path)
          logger.error "The first param BUILD_DIR must be a xcodeproj directory"
          exit 1
        end

        if is_project?(path)
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

      def check_and_find_workspace path
        unless File.exist?(path)
          logger.error "The first param BUILD_DIR must be a xcworkspace directory"
          exit 1
        end

        if is_workspace?(path)
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

      def check_scheme scheme_name
        if scheme_name.blank?
          logger.error "Must provide a scheme by `-s` option when build a workspace"
          exit 1
        end
      end

      def is_project? path
        File.extname(path) == '.xcodeproj'
      end

      def is_workspace? path
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
