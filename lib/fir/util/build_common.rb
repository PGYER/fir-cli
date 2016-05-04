# encoding: utf-8

module FIR
  module BuildCommon

    def initialize_build_common_options(args, options)
      @build_dir     = initialize_build_dir(args, options)
      @output_path   = initialize_output_path(options)
      @token         = options[:token] || current_token
      @changelog     = options[:changelog].to_s
      @short         = options[:short].to_s
      @name          = options[:name].to_s
      @proj          = options[:proj].to_s
      @export_qrcode = options[:qrcode]
    end

    def initialize_build_dir(args, options)
      build_dir = args.first.to_s
      if File.extname(build_dir) == '.git'
        args.shift && git_clone_build_dir(build_dir, options)
      elsif build_dir.blank? || !File.exist?(build_dir)
        Dir.pwd
      else
        args.shift && File.absolute_path(build_dir)
      end
    end

    def git_clone_build_dir(ssh_url, options)
      repo_name = File.basename(ssh_url, '.git') + "_#{Time.now.strftime('%Y%m%dT%H%M%S')}"
      branch    = options[:branch].blank? ? 'master' : options[:branch]
      git_cmd   = "git clone --depth=50 --branch=#{branch} #{ssh_url} #{repo_name}"

      logger.info git_cmd
      logger_info_dividing_line

      if system(git_cmd)
        File.absolute_path(repo_name)
      else
        logger.error 'Git clone failed'
        exit 1
      end
    end

    def initialize_output_path(options)
      if options[:output].blank?
        output_path = "#{@build_dir}/fir_build"
        FileUtils.mkdir_p(output_path) unless File.exist?(output_path)
        output_path
      else
        output_path = options[:output].to_s
        unless File.exist?(output_path)
          logger.warn "The output path not exist and fir-cli will autocreate it..."
        end
        File.absolute_path(output_path)
      end
    end

    def publish_build_app(options)
      logger_info_blank_line
      publish @builded_app_path, options
    end

    def logger_info_and_run_build_command
      puts @build_cmd if $DEBUG

      logger.info 'Building......'
      logger_info_dividing_line

      logger.info `#{@build_cmd}`

      if $?.to_i != 0
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
