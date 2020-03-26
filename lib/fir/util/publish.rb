# frozen_string_literal: true

# require 'byebug'
require_relative './qiniu_uploader'
require_relative './ali_uploader'

module FIR
  module Publish
    def publish(*args, options)
      initialize_publish_options(args, options)
      logger_info_publishing_message

      logger.info 'begin to upload ...'
      received_app_info = upload_app

      short = received_app_info[:short]
      download_domain = received_app_info[:download_domain]
      release_id = received_app_info[:release_id]

      logger.info 'end upload'

      logger_info_dividing_line

      download_url = build_download_url(download_domain, short, release_id)
      logger.info "Published succeed: #{download_url}"

      qrcode_path = build_qrcode download_url
      
      dingtalk_notifier(download_url, qrcode_path)
      feishu_notifier(download_url)
      wxwork_notifier(download_url)

      upload_mapping_file_with_publish

      upload_fir_cli_usage_info(received_app_info)

      logger_info_blank_line

      {
        app_id: @app_id,
        release_id: release_id,
        short: short
      }
    end

    def fetch_app_info
      logger.info 'Fetch app info from fir.im'

      fir_app_info = get(fir_api[:app_url] + "/#{@app_id}", api_token: @token)
      write_app_info(id: fir_app_info[:id],
                     short: fir_app_info[:short],
                     name: fir_app_info[:name])
      fir_app_info
    end

    protected

    def logger_info_publishing_message
      email = @user_info.fetch(:email, '')
      name  = @user_info.fetch(:name, '')

      logger.info "Publishing app via #{name}<#{email}>......."
      logger_info_dividing_line
    end

    def upload_app
      time1 = Time.now.to_i
      app_uploaded_callback_data = if @options[:switch_to_qiniu]
                                     QiniuUploader.new(@app_info, @user_info, @uploading_info, @options).upload
                                   else
                                     AliUploader.new(@app_info, @user_info, @uploading_info, @options).upload
                                   end

      during_seconds = Time.now.to_i - time1
      speed = File.size(@app_info[:file_path]) / during_seconds / 1024

      logger.info "File uploaded. During: #{during_seconds} seconds, Upload Speed: #{speed} KB/s "

      release_id = app_uploaded_callback_data[:release_id]

      logger.info "App id is #{@app_id}"
      logger.info "Release id is #{release_id}"

      # 处理上传完毕后, 需要的后续操作
      force_pin_release(release_id) if @force_pin_history
      upload_device_info
      update_app_info

      app_info_dict = fetch_app_info
      app_info_dict[:release_id] = release_id

      app_info_dict
    rescue StandardError => e
      puts e.message
      if e.respond_to?(e.response) && e.respond_to?(e.response.body)
        puts e.response.body
      end
      raise e
    end

    def upload_fir_cli_usage_info(received_app_info)
      return if @options[:skip_fir_cli_feedback]

      short = received_app_info[:short]
      AdmqrKnife.visit(
        unique_code: 'fir_cli_publish',
        tag: 'fir_cli',
        referer: "https://#{FIR::VERSION}.fir-cli/#{short}"
      )
    end

    def upload_device_info
      return if @app_info[:devices].blank?

      logger.info 'Updating devices info......'
      key = @uploading_info[:cert][:binary][:key]
      post fir_api[:udids_url], key: key,
                                udids: @app_info[:devices].join(','),
                                api_token: @token
    end

    def update_app_info
      update_info = { short: @short, passwd: @passwd, is_opened: @is_opened }.compact

      return if update_info.blank?

      logger.info 'Updating app info......'

      put fir_api[:app_url] + "/#{@app_id}", update_info.merge(api_token: @token)
    end

    # 获得 上传文件的授权信息
    def fetch_uploading_info
      logger.info "Fetching #{@app_info[:identifier]}@fir.im uploading info......"
      logger.info "Uploading app: #{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]})"

      post fir_api[:app_url],
           {  type: @app_info[:type],
              bundle_id: @app_info[:identifier],
              fname: @file_path.split('/').last,
              force_upload: options[:switch_to_qiniu] ? 'qiniu' : 'ali',
              skip_icon_upload: @options[:skip_update_icon],
              manual_callback: true,
              oversea_turbo: @options[:oversea_turbo],
              protocol: 'https',
              api_token: @token },
           header: {
             user_agent: 'new-cli'
           }
    end

    def upload_mapping_file_with_publish
      return if !options[:mappingfile] || !options[:proj]

      logger_info_blank_line

      mapping options[:mappingfile], proj: options[:proj],
                                     build: @app_info[:build],
                                     version: @app_info[:version],
                                     token: @token
    end

    def build_qrcode(download_url)
      qrcode_path = "#{File.dirname(@file_path)}/fir-#{@app_info[:name]}.png"
      FIR.generate_rqrcode(download_url, qrcode_path)

      # NOTE: showing with default options specified explicitly
      if @options[:need_ansi_qrcode]
        puts RQRCode::QRCode.new(download_url).as_ansi(
          light: "\033[47m", dark: "\033[40m",
          fill_character: '  ',
          quiet_zone_size: 1
        )
      end

      # 为何在这里必须生成 QrCode ? 因为要在 dingtalk 调用
      logger.info "Local qrcode file: #{qrcode_path}" if @export_qrcode
      qrcode_path
    end

    def build_download_url(download_domain, short, release_id)
      url = "http://#{download_domain}/#{short}"
      url += "?release_id=#{release_id}" if options[:need_release_id]
      url
    end

    def options
      @options
    end

    def force_pin_release(release_id)
      post "#{fir_api[:base_url]}/apps/#{@app_id}/releases/#{release_id}/force_set_history",
           api_token: @token
    end

    def dingtalk_notifier(download_url, qrcode_path)
      return if options[:dingtalk_access_token].blank?

      title = "#{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]})"
      payload = {
        "msgtype": 'markdown',
        "markdown": {
          "title": "#{title} uploaded",
          "text": "#{title} uploaded at #{Time.now}\nurl: #{download_url}\n#{options[:dingtalk_custom_message]}\n![app二维码](data:image/png;base64,#{Base64.strict_encode64(File.read(open(qrcode_path)))})"
          # "text": "#{title} uploaded at #{Time.now}\nurl: #{download_url}\n#{options[:dingtalk_custom_message]}\n"
        }
      }
      build_dingtalk_at_info(payload)
      url = "https://oapi.dingtalk.com/robot/send?access_token=#{options[:dingtalk_access_token]}"

      # 用完了二维码, 就删了
      File.delete(qrcode_path) unless @export_qrcode

      DefaultRest.post(url, payload)
    rescue StandardError => e
      logger.warn "Dingtalk send error #{e.message}"
    end

    def feishu_notifier(download_url)
      return if options[:feishu_access_token].blank?
      title = "#{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]})"
      url = "https://open.feishu.cn/open-apis/bot/hook/#{options[:feishu_access_token]}"
      payload = {
        "title": "#{title} uploaded",
        "text": "#{title} uploaded at #{Time.now}\nurl: #{download_url}\n#{options[:feishu_custom_message]}\n"
      }
      DefaultRest.post(url, payload) 
    end

    def wxwork_notifier(download_url)
      webhook_url = options[:wxwork_webhook]
      webhook_url ||= "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=#{options[:wxwork_access_token]}"
      return if webhook_url.blank?

      title = "#{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]})"
      payload = {
        "msgtype": "news",
        "news": {
          "articles": [{
            "title": "#{title} uploaded",
            "description": "#{title} uploaded at #{Time.now}\nurl: #{download_url}\n#{options[:wxwork_custom_message]}\n",
            "url": download_url,
            "picurl": options[:wxwork_pic_url]
          }],
        },
      }
      DefaultRest.post(webhook_url, payload)
    end

    def initialize_publish_options(args, options)
      @options = options
      @file_path = File.absolute_path(args.first.to_s)
      @file_type = File.extname(@file_path).delete('.')

      check_file_exist(@file_path)
      check_supported_file(@file_path)
      
      @token = options[:token] || current_token
      check_token_cannot_be_blank(@token)
      
      @changelog = read_changelog(options[:changelog]).to_s.to_utf8
      @short = options[:short].to_s
      @passwd = options[:password].to_s
      @is_opened = @passwd.blank? ? options[:open] : false
      @export_qrcode = !!options[:qrcode]
      @app_info = send("#{@file_type}_info", @file_path, options.merge(full_info: true))
      @user_info = fetch_user_info(@token)
      @uploading_info = fetch_uploading_info # 获得上传信息
      @app_id = @uploading_info[:id]

      @skip_update_icon = options[:skip_update_icon]
      @force_pin_history = options[:force_pin_history]
      unless options[:specify_icon_file].blank?
        @specify_icon_file_path = File.absolute_path(options[:specify_icon_file])
      end
    end

    def read_changelog(changelog)
      return if changelog.blank?

      File.exist?(changelog) ? File.read(changelog) : changelog
    end



    def build_dingtalk_at_info(payload)
      answer = {}
      answer[:isAtAll] = options[:dingtalk_at_all]

      unless options[:dingtalk_at_phones].blank?
        answer[:atMobiles] = options[:dingtalk_at_phones].split(',')
        payload[:markdown][:text] += options[:dingtalk_at_phones].split(',').map { |x| "@#{x}" }.join(',')
      end

      payload[:at] = answer
    end
  end
end
