# encoding: utf-8

module FIR
  module BuildIpa

    def build_ipa(*args, options)
      initialize_build_common_options(args, options)

      @build_tmp_dir = Dir.mktmpdir
      @build_cmd     = initialize_ipa_build_cmd(args, options)

      logger_info_and_run_build_command

      output_ipa
      @builded_app_path = Dir["#{@output_path}/*.ipa"].first

      publish_build_app if options.publish?
      upload_build_dsym_mapping_file if options.mapping?

      logger_info_blank_line
    end

    private

    def initialize_ipa_build_cmd(args, options)
      @configuration = options[:configuration]
      @wrapper_name  = File.basename(options[:name].to_s, '.*') + '.app' unless options[:name].blank?
      @target_name   = options[:target]
      @scheme_name   = options[:scheme]
      @dsym_name     = @wrapper_name + '.dSYM' unless @wrapper_name.blank?

      build_cmd =  'xcodebuild build -sdk iphoneos'
      build_cmd += initialize_xcode_build_path(options)
      build_cmd += " -configuration '#{@configuration}'" unless @configuration.blank?
      build_cmd += " -target '#{@target_name}'" unless @target_name.blank?
      build_cmd += " #{ipa_custom_settings(args)} 2>&1"
      build_cmd
    end

    def ipa_custom_settings(args)
      custom_settings = split_assignment_array_to_hash(args)

      setting_str =  convert_hash_to_assignment_string(custom_settings)
      setting_str += " WRAPPER_NAME='#{@wrapper_name}'" unless @wrapper_name.blank?
      setting_str += " TARGET_BUILD_DIR='#{@build_tmp_dir}'" unless custom_settings['TARGET_BUILD_DIR']
      setting_str += " CONFIGURATION_BUILD_DIR='#{@build_tmp_dir}'" unless custom_settings['CONFIGURATION_BUILD_DIR']
      setting_str += " DWARF_DSYM_FOLDER_PATH='#{@output_path}'" unless custom_settings['DWARF_DSYM_FOLDER_PATH']
      setting_str += " DWARF_DSYM_FILE_NAME='#{@dsym_name}'" unless @dsym_name.blank?
      setting_str
    end

    def output_ipa
      Dir.chdir(@build_tmp_dir) do
        apps = Dir['*.app']
        check_no_output_app(apps)

        apps.each do |app|
          ipa_path = File.join(@output_path, "#{File.basename(app, '.app')}-#{Time.now.to_i}.ipa")
          zip_app2ipa(File.join(@build_tmp_dir, app), ipa_path)
        end
      end

      logger.info 'Build Success'
    end

    def upload_build_dsym_mapping_file
      logger_info_blank_line

      @app_info     = ipa_info(@builded_app_path)
      @mapping_file = Dir["#{@output_path}/*.dSYM/Contents/Resources/DWARF/*"].first

      mapping @mapping_file, proj:    @proj,
                             build:   @app_info[:build],
                             version: @app_info[:version],
                             token:   @token
    end

    def initialize_xcode_build_path(options)
      if options.workspace?
        workspace = check_and_find_ios_xcworkspace(@build_dir)
        check_ios_scheme(@scheme_name)

        return " -workspace '#{workspace}' -scheme '#{@scheme_name}'"
      else
        project = check_and_find_ios_xcodeproj(@build_dir)

        return " -project '#{project}'"
      end
    end

    %w(xcodeproj xcworkspace).each do |workplace|
      define_method "check_and_find_ios_#{workplace}" do |path|
        unless File.exist?(path)
          logger.error "The first param BUILD_DIR must be a #{workplace} directory"
          exit 1
        end

        if File.extname(path) == ".#{workplace}"
          build_dir = path
        else
          build_dir = Dir["#{path}/*.#{workplace}"].first
          if build_dir.blank?
            logger.error "The #{workplace} file is missing, check the BUILD_DIR"
            exit 1
          end
        end

        build_dir
      end
    end

    def check_ios_scheme(scheme_name)
      if scheme_name.blank?
        logger.error 'Must provide a scheme by `-S` option when build a workspace'
        exit 1
      end
    end

    def check_no_output_app(apps)
      if apps.length == 0
        logger.error 'Builded has no output app, Can not be packaged'
        exit 1
      end
    end

    def zip_app2ipa(app_path, ipa_path)
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do
          Dir.mkdir('Payload')
          FileUtils.cp_r(app_path, 'Payload')
          system("rm -rf #{ipa_path}") if File.file? ipa_path
          system("zip -qr #{ipa_path} Payload")
        end
      end
    end
  end
end
