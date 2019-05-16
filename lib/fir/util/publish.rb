# frozen_string_literal: true
module FIR
  module Publish
    def publish(*args, options)
      initialize_publish_options(args, options)
      check_supported_file_and_token

      logger_info_publishing_message

      @app_info = send("#{@file_type}_info", @file_path, full_info: true)
      @user_info      = fetch_user_info(@token)
      @uploading_info = fetch_uploading_info
      @app_id         = @uploading_info[:id]

      upload_app

      logger_info_dividing_line
      logger_info_app_short_and_qrcode(options)

      dingtalk_notifier(options)
      upload_mapping_file_with_publish(options)
      logger_info_blank_line
      clean_files
    end

    def logger_info_publishing_message
      user_info = fetch_user_info(@token)

      email = user_info.fetch(:email, '')
      name  = user_info.fetch(:name, '')

      logger.info "Publishing app via #{name}<#{email}>......."
      logger_info_dividing_line
    end

    def upload_app
      @icon_cert   = @uploading_info[:cert][:icon]
      @binary_cert = @uploading_info[:cert][:binary]

      upload_app_icon unless @app_info[:icons].blank?
      @app_uploaded_callback_data = upload_app_binary
      logger.info "App id is #{@app_id}"
      logger.info "Release id is #{@app_uploaded_callback_data[:release_id]}"
      upload_device_info
      update_app_info
      fetch_app_info
    end

    %w[binary icon].each do |word|
      define_method("upload_app_#{word}") do
        upload_file(word)
        storage = ENV['SOTRAGE_NAME'] || 'qiniu'
        post("#{fir_api[:base_url]}/auth/#{storage}/callback", send("#{word}_information"))
      end
    end

    def upload_file(postfix)
      logger.info "Uploading app #{postfix}......"
      url = @uploading_info[:cert][postfix.to_sym][:upload_url]
      info = send("uploading_#{postfix}_info")
      logger.debug "url = #{url}, info = #{info}"
      uploaded_info = post(url, info.merge(manual_callback: true),
                           params_to_json: false,
                           header: nil)
    rescue StandardError
      logger.error "Uploading app #{postfix} failed"
      exit 1
    end

    def uploading_icon_info
      large_icon_path = @app_info[:icons].max_by { |f| File.size(f) }
      @uncrushed_icon_path = convert_icon(large_icon_path)
      {
        key: @icon_cert[:key],
        token: @icon_cert[:token],
        file: File.new(@uncrushed_icon_path, 'rb'),
        'x:is_converted' => '1'
      }
    end

    def icon_information
      {
        key: @icon_cert[:key],
        token: @icon_cert[:token],
        origin: 'fir-cli',
        parent_id: @app_id,
        fsize: File.size(@uncrushed_icon_path),
        fname: 'blob'
      }
    end

    def binary_information
      {
        build: @app_info[:build],
        fname: File.basename(@file_path),
        key: @binary_cert[:key],
        name: @app_info[:display_name] || @app_info[:name],
        origin: 'fir-cli',
        parent_id: @app_id,
        release_tag: 'develop',
        fsize: File.size(@file_path),
        release_type: @app_info[:release_type],
        distribution_name: @app_info[:distribution_name],
        token: @binary_cert[:token],
        version: @app_info[:version],
        changelog: @changelog,
        user_id: @user_info[:id]
      }.reject { |x| x.nil? || x == '' }
    end

    def uploading_binary_info
      {
        key: @binary_cert[:key],
        token: @binary_cert[:token],
        file: File.new(@file_path, 'rb'),
        # Custom variables
        'x:name' => @app_info[:display_name] || @app_info[:name],
        'x:build' => @app_info[:build],
        'x:version' => @app_info[:version],
        'x:changelog' => @changelog,
        'x:release_type' => @app_info[:release_type],
        'x:distribution_name' => @app_info[:distribution_name]
      }
    end

    def upload_device_info
      return if @app_info[:devices].blank?

      logger.info 'Updating devices info......'

      post fir_api[:udids_url], key: @binary_cert[:key],
                                udids: @app_info[:devices].join(','),
                                api_token: @token
      end

    def update_app_info
      update_info = { short: @short, passwd: @passwd, is_opened: @is_opened }.compact

      return if update_info.blank?

      logger.info 'Updating app info......'

      patch fir_api[:app_url] + "/#{@app_id}", update_info.merge(api_token: @token)
    end

    def fetch_uploading_info
      logger.info "Fetching #{@app_info[:identifier]}@fir.im uploading info......"
      logger.info "Uploading app: #{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]})"

      post fir_api[:app_url], type: @app_info[:type],
                              bundle_id: @app_info[:identifier],
                              manual_callback: true,
                              api_token: @token
    end

    def fetch_release_id
      get "#{fir_api[:base_url]}/apps/#{@app_id}/releases/find_release_by_key", api_token: @token, key: @binary_cert[:key]
    end

    def fetch_app_info
      logger.info 'Fetch app info from fir.im'

      @fir_app_info = get(fir_api[:app_url] + "/#{@app_id}", api_token: @token)
      write_app_info(id: @fir_app_info[:id], short: @fir_app_info[:short], name: @fir_app_info[:name])
      @fir_app_info
    end

    def upload_mapping_file_with_publish(options)
      return if !options[:mappingfile] || !options[:proj]

      logger_info_blank_line

      mapping options[:mappingfile], proj: options[:proj],
                                     build: @app_info[:build],
                                     version: @app_info[:version],
                                     token: @token
    end

    def logger_info_app_short_and_qrcode(options)
      @download_url = "#{fir_api[:domain]}/#{@fir_app_info[:short]}"
      @download_url += "?release_id=#{@app_uploaded_callback_data[:release_id]}" if !!options[:need_release_id]

      logger.info "Published succeed: #{@download_url}"

      @qrcode_path = "#{File.dirname(@file_path)}/fir-#{@app_info[:name]}.png"
      FIR.generate_rqrcode(@download_url, @qrcode_path)

      logger.info "Local qrcode file: #{@qrcode_path}" if @export_qrcode
    end

    private

    def clean_files
      File.delete(@qrcode_path) unless @export_qrcode
    end

    def dingtalk_notifier(options)
      if options[:dingtalk_access_token]
        title = "#{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]})"
        payload = {
          "msgtype": 'markdown',
          "markdown": {
            "title": "#{title} uploaded",
            "text": "#{title} uploaded at #{Time.now}\nurl: #{@download_url}\n ![app二维码](data:image/png;base64,#{Base64.strict_encode64(File.read(open(@qrcode_path)))})"
          }
        }
        url = "https://oapi.dingtalk.com/robot/send?access_token=#{options[:dingtalk_access_token]}"
        DefaultRest.post(url, payload)
      end
    rescue StandardError => e
      logger.warn "Dingtalk send error #{e.message}"
    end

    def initialize_publish_options(args, options)
      @file_path     = File.absolute_path(args.first.to_s)
      @file_type     = File.extname(@file_path).delete('.')
      @token         = options[:token] || current_token
      @changelog     = read_changelog(options[:changelog]).to_s.to_utf8
      @short         = options[:short].to_s
      @passwd        = options[:password].to_s
      @is_opened     = @passwd.blank? ? options[:open] : false
      @export_qrcode = !!options[:qrcode]
    end

    def read_changelog(changelog)
      return if changelog.blank?

      File.exist?(changelog) ? File.read(changelog) : changelog
    end

    def check_supported_file_and_token
      check_file_exist(@file_path)
      check_supported_file(@file_path)
      check_token_cannot_be_blank(@token)
      fetch_user_info(@token)
    end

    def convert_icon(origin_path)
      # 兼容性不太好, 蔽掉转化图标
      return origin_path

      logger.info "Converting app's icon......"

      if @app_info[:type] == 'ios'
        output_path = Tempfile.new(['uncrushed_icon', '.png']).path
        FIR::Parser::Pngcrush.uncrush_icon(origin_path, output_path)
        origin_path = output_path if File.size(output_path) != 0
      end

      origin_path
    end
  end
end
