# encoding: utf-8

module FIR
  module Publish

    def publish *args, options
      file_path = File.absolute_path(args.first.to_s)
      token     = options[:token] || current_token
      changelog = options[:changelog].to_s

      check_supported_file(file_path)
      check_token_cannot_be_blank(token)
      fetch_user_info(token)

      logger.info "Publishing app......."
      logger_info_dividing_line

      file_type = File.extname(file_path).delete(".")
      @app_info = send("#{file_type}_info", file_path, true)

      uploading_info = fetch_uploading_info(type:      @app_info[:type],
                                            bundle_id: @app_info[:identifier],
                                            api_token: token)

      app_id      = uploading_info[:id]
      icon_cert   = uploading_info[:cert][:icon]
      binary_cert = uploading_info[:cert][:binary]

      unless @app_info[:icons].blank?
        large_icon_path = @app_info[:icons].max_by { |f| File.size(f) }
        upload_app_icon(icon_cert, large_icon_path)
      end

      uploaded_info = upload_app_binary(binary_cert, file_path, changelog)

      if uploaded_info[:is_completed]
        unless @app_info[:devices].blank?
          upload_device_info(key:       binary_cert[:key],
                             udids:     @app_info[:devices].join(","),
                             api_token: token)
        end

        unless options[:short].blank?
          update_app_info(app_id, short: options[:short], api_token: token)
        end

        published_app_info = fetch_app_info(app_id, api_token: token)

        logger_info_dividing_line
        logger.info "Published succeed: #{fir_api[:domain]}/#{published_app_info[:short]}"
      end
    end

    private

      def upload_app_icon icon_cert, icon_path
        logger.info "Uploading app's icon......"
        hash = {
          key:   icon_cert[:key],
          token: icon_cert[:token],
          file:  File.new(icon_path, "rb")
        }
        post icon_cert[:upload_url], hash
      end

      def upload_app_binary binary_cert, file_path, changelog
        logger.info "Uploading app......"
        hash = {
          key:   binary_cert[:key],
          token: binary_cert[:token],
          file:  File.new(file_path, "rb"),
          # Custom variables
          "x:name"         => @app_info[:display_name] || @app_info[:name],
          "x:build"        => @app_info[:build],
          "x:version"      => @app_info[:version],
          "x:changelog"    => changelog,
          "x:release_type" => @app_info[:release_type],
        }
        post binary_cert[:upload_url], hash
      end

      def upload_device_info hash
        logger.info "Updating devices info......"
        post fir_api[:udids_url], hash
      end

      def update_app_info id, hash
        logger.info "Updating app info......"
        patch fir_api[:app_url] + "/#{id}", hash
      end

      def fetch_uploading_info hash
        logger.info "Fetching #{@app_info[:identifier]}@FIR.im uploading info......"

        post fir_api[:app_url], hash
      end

      def fetch_app_info id, hash
        logger.info "Fetch app info from FIR.im"
        get fir_api[:app_url] + "/#{id}", hash
      end
  end
end
