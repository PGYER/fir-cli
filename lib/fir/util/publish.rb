# encoding: utf-8

module FIR
  module Publish

    def publish(*args, options)
      initialize_publish_options(args, options)
      check_supported_file_and_token

      logger_info_publishing_message

      @app_info       = send("#{@file_type}_info", @file_path, full_info: true)
      @uploading_info = fetch_uploading_info
      @app_id         = @uploading_info[:id]

      upload_app

      logger_info_dividing_line
      logger_info_app_short_and_qrcode

      upload_mapping_file_with_publish(options)
      logger_info_blank_line
    end

    def logger_info_publishing_message
      user_info = fetch_user_info(@token)

      email = user_info.fetch(:email, '')
      name  = user_info.fetch(:name, '')

      logger.info "Publishing app from #{email}/#{name}......."
      logger_info_dividing_line
    end

    def upload_app
      @icon_cert   = @uploading_info[:cert][:icon]
      @binary_cert = @uploading_info[:cert][:binary]

      upload_app_icon unless @app_info[:icons].blank?
      upload_app_binary
      upload_device_info
      update_app_info
    end

    def upload_app_icon
      logger.info 'Uploading app icon......'

      uploaded_info = post(@icon_cert[:upload_url], uploading_icon_info)

      return if uploaded_info[:is_completed]

      logger.error 'Upload app icon failed'
      exit 1
    end

    def uploading_icon_info
      icon = @app_info[:icons].max_by { |f| File.size(f) }

      {
        key:   @icon_cert[:key],
        token: @icon_cert[:token],
        file:  File.new(icon, 'rb')
      }
    end

    def upload_app_binary
      logger.info 'Uploading app binary......'

      uploaded_info = post(@binary_cert[:upload_url], uploading_binary_info)

      return if uploaded_info[:is_completed]

      logger.error 'Upload app binary failed'
      exit 1
    end

    def uploading_binary_info
      {
        key:   @binary_cert[:key],
        token: @binary_cert[:token],
        file:  File.new(@file_path, 'rb'),
        # Custom variables
        'x:name'         => @app_info[:display_name] || @app_info[:name],
        'x:build'        => @app_info[:build],
        'x:version'      => @app_info[:version],
        'x:changelog'    => @changelog,
        'x:release_type' => @app_info[:release_type]
      }
    end

    def upload_device_info
      return if @app_info[:devices].blank?

      logger.info 'Updating devices info......'

      post fir_api[:udids_url], key:       @binary_cert[:key],
                                udids:     @app_info[:devices].join(','),
                                api_token: @token
    end

    def update_app_info
      return if @short.blank?

      logger.info 'Updating app info......'

      patch fir_api[:app_url] + "/#{@app_id}", short:     @short,
                                               api_token: @token
    end

    def fetch_uploading_info
      logger.info "Fetching #{@app_info[:identifier]}@fir.im uploading info......"

      post fir_api[:app_url], type:      @app_info[:type],
                              bundle_id: @app_info[:identifier],
                              api_token: @token
    end

    def fetch_app_info
      logger.info 'Fetch app info from fir.im'

      get fir_api[:app_url] + "/#{@app_id}", api_token: @token
    end

    def upload_mapping_file_with_publish(options)
      return if !options[:mappingfile] || !options[:proj]

      logger_info_blank_line

      mapping options[:mappingfile], proj:    options[:proj],
                                     build:   @app_info[:build],
                                     version: @app_info[:version],
                                     token:   @token
    end

    def logger_info_app_short_and_qrcode
      short = "#{fir_api[:domain]}/#{fetch_app_info[:short]}"

      logger.info "Published succeed: #{short}"

      if @export_qrcode
        qrcode_path = "#{File.dirname(@file_path)}/fir-#{@app_info[:name]}.png"
        FIR.generate_rqrcode(short, qrcode_path)

        logger.info "Local qrcode file: #{qrcode_path}"
      end
    end

    private

    def initialize_publish_options(args, options)
      @file_path     = File.absolute_path(args.first.to_s)
      @file_type     = File.extname(@file_path).delete('.')
      @token         = options[:token] || current_token
      @changelog     = options[:changelog].to_s.to_utf8
      @short         = options[:short].to_s
      @export_qrcode = !!options[:qrcode]
    end

    def check_supported_file_and_token
      check_file_exist(@file_path)
      check_supported_file(@file_path)
      check_token_cannot_be_blank(@token)
      fetch_user_info(@token)
    end
  end
end
