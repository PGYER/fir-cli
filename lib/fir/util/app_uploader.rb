# frozen_string_literal: true

module FIR
  class AppUploader
    include ApiTools::DefaultRestModule
    include Config

    attr_accessor :app_info, :user_info, :uploading_info, :options
    def initialize(app_info, user_info, uploading_info, options)
      @app_info = app_info
      @user_info = user_info
      @uploading_info = uploading_info
      @options = options
    end

    def upload
      upload_icon
      binary_callback_info = upload_binary
      raise binary_callback_info if binary_callback_info.is_a? StandardError

      # 将 binary 的callback信息返回
      binary_callback_info
    end

    protected

    def callback_to_api(callback_url, callback_binary_information)
      logger.debug 'begin to callback api'
      return if callback_binary_information.blank?

      answer = post callback_url, callback_binary_information, timeout: 20
      logger.debug 'callback api finished'
      answer
    end

    def icon_file_path
      if options[:specify_icon_file].blank?
        app_info[:icons].max_by { |f| File.size(f) }
      else
        File.absolute_path(options[:specify_icon_file])
      end
    end

    # 是否跳过 icon 上传
    def skip_update_icon?
      options[:skip_update_icon].to_s == 'true'
    end

    def read_changelog
      changelog = options[:changelog].to_s.to_utf8
      return if changelog.blank?

      File.exist?(changelog) ? File.read(changelog) : changelog
    end

    def icon_cert
      uploading_info[:cert][:icon]
    end

    def binary_cert
      uploading_info[:cert][:binary]
    end

    def file_path
      app_info[:file_path]
    end

    def try_to_action(action, &block)
      logger.debug "begin to #{action}"
      answer = block.call
      logger.debug "#{action} finished"
      answer
    rescue StandardError => e
      logger.error "#{action} error ! #{e.message}"
      raise e
    end

    def app_id
      uploading_info[:id]
    end

    def callback_icon_information
      return {} if icon_file_path.nil?

      {
        key: icon_cert[:key],
        token: icon_cert[:token],
        origin: 'fir-cli',
        parent_id: app_id,
        fsize: File.size(icon_file_path),
        fname: 'blob'
      }
    end

    def callback_binary_information
      {
        build: app_info[:build],
        fname: File.basename(file_path),
        key: binary_cert[:key],
        name: options[:specify_app_display_name] || app_info[:display_name] || app_info[:name],
        origin: 'fir-cli',
        parent_id: app_id,
        release_tag: 'develop',
        fsize: File.size(file_path),
        release_type: app_info[:release_type],
        distribution_name: app_info[:distribution_name],
        token: binary_cert[:token],
        version: app_info[:version],
        changelog: read_changelog,
        user_id: user_info[:id]
      }.reject { |x| x.nil? || x == '' }
    end

    def logger
      FIR.logger
    end
  end
end
