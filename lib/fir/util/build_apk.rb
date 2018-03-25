# encoding: utf-8

module FIR
  module BuildApk

    def build_apk(*args, options)
      logger.warn "build 在 fir-cli 即将过期, 推荐使用 gradlew 打包 apk文件后 后再使用 fir 工具上传生成的apk 文件"
      initialize_build_common_options(args, options)
      set_flavor(options)

      Dir.chdir(@build_dir)
      @build_cmd = initialize_apk_build_cmd

      logger_info_and_run_build_command

      output_apk
      publish_build_app(options) if options.publish?

      logger_info_blank_line
    end

    private

    def set_flavor(options)
      unless options.flavor.blank?
        @flavor = options.flavor
        unless @flavor =~ /^assemble(.+)/
          @flavor = "assemble#{@flavor}Release"
        end
      end
    end

    def initialize_apk_build_cmd
      check_build_gradle_exist

      cmd = "./gradlew build"
      cmd = "./gradlew #{@flavor}" unless @flavor.blank?
      cmd
    end

    def gradle_build_path
      "#{@build_dir}/build/outputs/apk"
    end

    def prefix_gradle_build_path
      "#{@build_dir}/app/build/outputs/apk"
    end

    def output_apk
      @builded_apk ||= Dir["#{gradle_build_path}/*.apk"].find { |i| i =~ /release/ }
      @builded_apk ||= Dir["#{prefix_gradle_build_path}/*.apk"].find { |i| i =~ /release/ }
      @builded_apk ||= Dir["#{@build_dir}/*.apk"].find { |i| i =~ /release/ }

      check_no_output_apk

      apk_info  = FIR.apk_info(@builded_apk)
      @apk_name = @name.blank? ? "#{apk_info[:name]}-#{apk_info[:version]}-Build-#{apk_info[:build]}" : @name

      @builded_app_path = "#{@output_path}/#{@apk_name}.apk"
      FileUtils.cp(@builded_apk, @builded_app_path)
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
