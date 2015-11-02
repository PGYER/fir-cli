# encoding: utf-8

module FIR
  module BuildApk

    def build_apk(*args, options)
      initialize_build_common_options(args, options)

      Dir.chdir(@build_dir)

      @build_cmd = initialize_apk_build_cmd

      logger_info_and_run_build_command

      output_apk
      @builded_app_path = Dir["#{@output_path}/*.apk"].first

      publish_build_app if options.publish?

      logger_info_blank_line
    end

    private

    def initialize_apk_build_cmd
      check_build_gradle_exist

      apk_build_cmd = 'gradle clean;gradle build'
      apk_build_cmd
    end

    def gradle_build_path
      "#{@build_dir}/build/outputs/apk"
    end

    def output_apk
      @builded_apk ||= Dir["#{gradle_build_path}/*.apk"].find { |i| i =~ /release/ }
      @builded_apk ||= Dir["#{@build_dir}/*.apk"].find { |i| i =~ /release/ }

      check_no_output_apk

      apk_info = FIR.apk_info(@builded_apk)

      if @name.blank?
        apk_name = "#{apk_info[:name]}-#{apk_info[:version]}-Build-#{apk_info[:build]}"
      else
        apk_name = @name
      end

      FileUtils.cp(@builded_apk, "#{@output_path}/#{apk_name}.apk")
    end

    def check_no_output_apk
      unless @builded_apk
        logger.error 'Builded has no output apk'
        exit 1
      end
    end

    def check_build_gradle_exist
      return if File.exist?("#{@build_dir}/build.gradle")

      logger.error "The build.gradle isn't exit, please use gradle and edit"
      exit 1
    end
  end
end
