# frozen_string_literal: true

require_relative './app_uploader'
# require 'byebug'

module FIR
  class QiniuUploader < AppUploader
    def upload_icon
      if skip_update_icon?
        logger.info 'skip update icon...'
        return
      end
      try_to_action('upload icon') do
        # 拿到 icon 的授权
        icon_url = uploading_info[:cert][:icon][:upload_url]
        icon_info = uploading_icon_info

        logger.debug "icon_url = #{icon_url}, icon_info = #{icon_info}"

        _uploaded_info = post(icon_url, icon_info.merge(manual_callback: true),
                              params_to_json: false,
                              header: nil)

        callback_to_api(callback_url, callback_icon_information)
      end
    rescue StandardError => e
      # ignore icon error
      logger.info "ignore icon upload error #{e.message}"
    end

    def upload_binary
      try_to_action 'upload binary ...' do
        binary_url = uploading_info[:cert][:binary][:upload_url]
        binary_info = uploading_binary_info

        _uploaded_info = post(binary_url, binary_info.merge(manual_callback: true),
                              params_to_json: false,
                              header: nil)

        callback_to_api(callback_url, callback_binary_information)
      end
    rescue StandardError => e
      logger.error "binary upload to qiniu fail, #{e.message}"
      exit 1
    end

    protected

    def callback_url
      "#{fir_api[:base_url]}/auth/qiniu/callback"
    end

    # 七牛需要的 icon params
    def uploading_icon_info
      icon_cert = uploading_info[:cert][:icon]
      {
        key: icon_cert[:key],
        token: icon_cert[:token],
        file: File.new(icon_file_path, 'rb')
      }
    end

    # 七牛需要的 binary params
    def uploading_binary_info
      binary_cert = uploading_info[:cert][:binary]
      {
        key: binary_cert[:key],
        token: binary_cert[:token],
        file: File.new(file_path, 'rb')
      }
    end
  end
end
