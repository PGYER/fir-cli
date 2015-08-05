# encoding: utf-8

module FIR
  module BuildCommon

    def initialize_build_common_options args, options
      if args.first.blank? || !File.exist?(args.first)
        @build_dir = Dir.pwd
      else
        @build_dir = File.absolute_path(args.shift.to_s) # pop the first param
      end

      @token     = options[:token] || current_token
      @changelog = options[:changelog].to_s
      @short     = options[:short].to_s
      @proj      = options[:proj].to_s
    end

    def publish_build_app
      logger_info_blank_line
      publish @builded_app_path, short:     @short,
                                 changelog: @changelog,
                                 token:     @token
    end

    def logger_info_and_run_build_command
      puts @build_cmd if $DEBUG

      logger.info "Building......"
      logger_info_dividing_line

      logger.info `#{@build_cmd}`
    end
  end
end
