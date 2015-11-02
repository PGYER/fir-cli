# encoding: utf-8

module FIR
  module BuildCommon

    def initialize_build_common_options(args, options)
      @build_dir     = initialize_build_dir(args)
      @output_path   = initialize_output_path(options)
      @token         = options[:token] || current_token
      @changelog     = options[:changelog].to_s
      @short         = options[:short].to_s
      @name          = options[:name].to_s
      @proj          = options[:proj].to_s
      @export_qrcode = options[:qrcode]
    end

    def initialize_build_dir(args)
      if args.first.blank? || !File.exist?(args.first)
        Dir.pwd
      else
        File.absolute_path(args.shift.to_s) # pop the first param
      end
    end

    def initialize_output_path(options)
      if options[:output].blank?
        output_path = "#{@build_dir}/fir_build"
        FileUtils.mkdir_p(output_path) unless File.exist?(output_path)
        output_path
      else
        File.absolute_path(options[:output].to_s)
      end
    end

    def publish_build_app
      logger_info_blank_line
      publish @builded_app_path, short:     @short,
                                 changelog: @changelog,
                                 token:     @token,
                                 qrcode:    @export_qrcode
    end

    def logger_info_and_run_build_command
      puts @build_cmd if $DEBUG

      logger.info 'Building......'
      logger_info_dividing_line

      status = system(@build_cmd)

      unless status
        logger.error 'Build failed'
        exit 1
      end
    end

    # split ['a=1', 'b=2'] => { 'a' => '1', 'b' => '2' }
    def split_assignment_array_to_hash(arr)
      hash = {}
      arr.each do |assignment|
        k, v = assignment.split('=', 2).map(&:strip)
        hash[k] = v
      end

      hash
    end

    # convert { "a" => "1", "b" => "2" } => "a='1' b='2'"
    def convert_hash_to_assignment_string(hash)
      hash.collect { |k, v| "#{k}='#{v}'" }.join(' ')
    end
  end
end
