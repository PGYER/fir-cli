# encoding: utf-8

module FIR
  module Publish

    def publish *args, options
      @file_path = File.absolute_path(args.first.to_s)
      @token     = options[:token] || current_token
      @changelog = options[:changelog].to_s
      @short     = options[:short].to_s

      check_file_exist @file_path
      check_supported_file @file_path
      check_token_cannot_be_blank @token
      fetch_user_info @token

      logger.info "Publishing app......."
      logger_info_dividing_line

      file_type = File.extname(@file_path).delete(".")

      @app_info       = send("#{file_type}_info", @file_path, true)
      @uploading_info = fetch_uploading_info
      @app_id         = @uploading_info[:id]

      upload_app

      logger_info_dividing_line
      logger.info "Published succeed: #{fir_api[:domain]}/#{fetch_app_info[:short]}"

      if options[:mappingfile] && options[:proj]
        logger_info_blank_line

        mapping options[:mappingfile], proj:    options[:proj],
                                       build:   @app_info[:build],
                                       version: @app_info[:version],
                                       token:   @token
      end

      logger_info_blank_line
    end

    private

      def upload_app
        @icon_cert   = @uploading_info[:cert][:icon]
        @binary_cert = @uploading_info[:cert][:binary]

        upload_app_icon
        upload_app_binary
        upload_device_info
        update_app_info
      end

      def upload_app_icon
        unless @app_info[:icons].blank?
          logger.info "Uploading app's icon......"

          icon_path = @app_info[:icons].max_by { |f| File.size(f) }

          hash = {
            key:   @icon_cert[:key],
            token: @icon_cert[:token],
            file:  File.new(icon_path, "rb")
          }

          uploaded_info = post(@icon_cert[:upload_url], hash)

          unless uploaded_info[:is_completed]
            logger.error "Upload app icon failed"
            exit 1
          end
        end
      end

      def upload_app_binary
        logger.info "Uploading app......"

        hash = {
          key:   @binary_cert[:key],
          token: @binary_cert[:token],
          file:  File.new(@file_path, "rb"),
          # Custom variables
          "x:name"         => @app_info[:display_name] || @app_info[:name],
          "x:build"        => @app_info[:build],
          "x:version"      => @app_info[:version],
          "x:changelog"    => @changelog,
          "x:release_type" => @app_info[:release_type],
        }

        uploaded_info = post(@binary_cert[:upload_url], hash)

        unless uploaded_info[:is_completed]
          logger.error "Upload app binary failed"
          exit 1
        end
      end

      def upload_device_info
        unless @app_info[:devices].blank?
          logger.info "Updating devices info......"

          post fir_api[:udids_url], key:       @binary_cert[:key],
                                    udids:     @app_info[:devices].join(","),
                                    api_token: @token
        end
      end

      def update_app_info
        unless @short.blank?
          logger.info "Updating app info......"

          patch fir_api[:app_url] + "/#{@app_id}", short:     @short,
                                                   api_token: @token
        end
      end

      def fetch_uploading_info
        logger.info "Fetching #{@app_info[:identifier]}@FIR.im uploading info......"

        post fir_api[:app_url], type:      @app_info[:type],
                                bundle_id: @app_info[:identifier],
                                api_token: @token
      end

      def fetch_app_info
        logger.info "Fetch app info from FIR.im"

        get fir_api[:app_url] + "/#{@app_id}", api_token: @token
      end
  end
end
