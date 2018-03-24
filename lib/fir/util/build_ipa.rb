# encoding: utf-8
require 'xcodeproj'

module FIR
  module BuildIpa

    def build_ipa(*args, options)

      logger.warn "fir build ipa 即将过期, 请及时迁移打包部分, 推荐使用 fastlane gym"
      initialize_build_common_options(args, options)

      @build_tmp_dir = Dir.mktmpdir
      @build_cmd = initialize_ipa_build_cmd(args, options)

      logger_info_and_run_build_command

      output_ipa_and_dsym
      publish_build_app(options) if options.publish?
      upload_build_dsym_mapping_file if options.mapping?

      logger_info_blank_line
    end

    private

    def initialize_ipa_build_cmd(args, options)
      @configuration = options[:configuration] || 'Release'
      @target_name = options[:target]
      @scheme_name = options[:scheme]
      @profile_name = options[:profile]
      @destination = options[:destination]
      @export_method = options[:export_method] || 'ad-hoc'
      @optionPlistPath = options[:optionPlistPath]

      build_cmd = 'xcodebuild archive -sdk iphoneos'
      build_cmd += initialize_xcode_build_path(options)

      build_settings = find_build_setting
      @team_id = build_settings['DEVELOPMENT_TEAM']
      provisioning_profile_id = build_settings['PROVISIONING_PROFILE']

      check_ios_scheme(@scheme_name)
      build_cmd += " -scheme '#{@scheme_name}'" unless @scheme_name.blank?
      build_cmd += " -configuration '#{@configuration}'" unless @configuration.blank?

      # build_cmd += " -target '#{@target_name}'" unless @target_name.blank?

      # xcarchive name for build -exportArchive
      @xcarchive_name = @scheme_name.nil? ? @target_name : @scheme_name + '.xcarchive'
      @xcarchive_path = "#{@build_dir}/fir_build/#{@xcarchive_name}"

      build_cmd += " -archivePath #{@xcarchive_path}"
      build_cmd += " PROVISIONING_PROFILE='#{provisioning_profile_id}'"
      build_cmd += " #{ipa_custom_settings(args)} 2>&1"
      build_cmd
    end

    def ipa_custom_settings(args)
      custom_settings = split_assignment_array_to_hash(args)

      setting_str = convert_hash_to_assignment_string(custom_settings)
      setting_str += " TARGET_BUILD_DIR='#{@build_tmp_dir}'" unless custom_settings['TARGET_BUILD_DIR']
      setting_str += " CONFIGURATION_BUILD_DIR='#{@build_tmp_dir}'" unless custom_settings['CONFIGURATION_BUILD_DIR']
      setting_str += " DWARF_DSYM_FOLDER_PATH='#{@output_path}'" unless custom_settings['DWARF_DSYM_FOLDER_PATH']
      setting_str
    end

    def output_ipa_and_dsym
      apps = Dir["#{@build_tmp_dir}/*.app"].sort_by(&:size)
      # check_no_output_app(apps)

      @temp_ipa = "#{@build_tmp_dir}/#{Time.now.to_i}.ipa"
      archive_ipa(apps)

      # check_archived_ipa_is_exist
      rename_ipa_and_dsym

      FileUtils.rm_rf(@build_tmp_dir) unless $DEBUG
      logger.info 'Build Success'
    end

    def archive_ipa(apps)
      logger.info 'Archiving......'
      logger_info_dividing_line

      option_plist_path = @optionPlistPath || gen_option_plist

      @xcrun_cmd = "#{FIR::Config::XCODE_WRAPPER_PATH} -exportArchive"
      @xcrun_cmd += " -archivePath #{@xcarchive_path}"
      @xcrun_cmd += " -exportOptionsPlist #{option_plist_path}"
      @xcrun_cmd += " -exportPath #{@build_dir}/fir_build"

      puts @xcrun_cmd if $DEBUG
      logger.info `#{@xcrun_cmd}`
    end

    def check_archived_ipa_is_exist
      unless File.exist?(@temp_ipa)
        logger.error 'Archive failed'
        exit 1
      end
    end

    def gen_option_plist
      plist = "
<plist version=\"1.0\">
<dict>
        <key>teamID</key>
        <string>#{@team_id}</string>
        <key>method</key>
        <string>#{@export_method}</string>
        <key>uploadSymbols</key>
        <true/>
        <key>compileBitcode</key>
        <false/>
        <key>uploadBitcode</key>
        <false/>
</dict>
</plist>"

      logger.info 'Generated plist file for exportOptionsPlist argument'
      logger.info "{"
      logger.info "  teamID:#{@team_id}" unless @team_id.nil?
      logger.info "  method:#{@export_method}"
      logger.info "  uploadSymbols:true"
      logger.info "  uploadBitcode:false"
      logger.info "}"

      begin
        plist_path = "#{@build_dir}/fir_build/exportOptions.plist"
        file = File.open(plist_path, "w")
        file.write(plist)
        plist_path
      rescue IOError => e
        raise e
      ensure
        file.close unless file.nil?
      end
    end

    # Find build setting from xcode project by target and configuration
    def find_build_setting
      project = Xcodeproj::Project.open(@xc_project)

      # find target
      used_target = project.targets[0]
      if @target_name
        project.targets.each do |target|
          if target.name == @target_name
            used_target = target
          end
        end
      end

      # find configuration settings
      used_target.build_configurations.each do |config|
        if config.name == @configuration
          return config.build_settings
        end
      end

      logger.info "configuration '#{@configuration}' not found"
    end

    def rename_ipa_and_dsym
      @temp_ipa = "#{@build_dir}/fir_build/#{@scheme_name}.ipa"
      ipa_info = FIR.ipa_info(@temp_ipa)

      if @name.blank?
        @ipa_name = "#{ipa_info[:name]}-#{ipa_info[:version]}-build-#{ipa_info[:build]}"
      else
        @ipa_name = @name
      end

      @builded_app_path = "#{@output_path}/#{@ipa_name}.ipa"
      dsym_name = " #{@output_path}/#{ipa_info[:name]}.app.dSYM"

      FileUtils.mv(@temp_ipa, @builded_app_path, force: true)
      if File.exist?(dsym_name)
        FileUtils.mv(dsym_name, "#{@output_path}/#{@ipa_name}.app.dSYM", force: true)
      end
    end

    def upload_build_dsym_mapping_file
      logger_info_blank_line

      @app_info = ipa_info(@builded_app_path)
      @mapping_file = Dir["#{@output_path}/#{@ipa_name}.app.dSYM/Contents/Resources/DWARF/*"].first

      mapping @mapping_file, proj: @proj,
              build: @app_info[:build],
              version: @app_info[:version],
              token: @token
    end

    def initialize_xcode_build_path(options)
      @xc_workspace = check_and_find_ios_xcworkspace(@build_dir)
      @xc_project = check_and_find_ios_xcodeproj(@build_dir)

      if options.workspace?
        " -workspace '#{@xc_workspace}'"
      else
        " -project '#{@xc_project}'"
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
  end
end
