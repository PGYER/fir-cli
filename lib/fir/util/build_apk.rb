# encoding: utf-8

module FIR
  module BuildApk

    def build_apk *args, options
      initialize_build_common_options(args, options)

      @build_cmd = initialize_apk_build_cmd(args, options)

      logger_info_and_run_build_command

      @builded_app_path = Dir["#{@output_path}/release.apk"].first || Dir["#{@output_path}/*.apk"].first
      publish_build_app if options.publish?

      logger_info_blank_line
    end

    private

      def initialize_apk_build_cmd args, options
        check_build_gradle_exist

        apk_build_cmd = "gradle clean;gradle build"
        apk_build_cmd
      end

      def check_build_gradle_exist
        unless File.exist?("#{@build_dir}/build.gradle")
          logger.error "The build.gradle is not exit, please use gradle and edit"
          exit 1
        end
      end
  end
end
