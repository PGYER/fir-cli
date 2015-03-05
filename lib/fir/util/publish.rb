# encoding: utf-8

module FIR
  module Publish

    def publish *args, options
      file_path = File.absolute_path(args.first.to_s)
      token     = options[:token] || current_token
      changelog = options[:changelog].to_s

      check_supported_file file_path
      check_token_cannot_be_blank token
      fetch_user_info(token)

      logger.info "Publishing app......."
      logger_info_dividing_line

      file_type      = File.extname(file_path).delete('.')
      app_info       = send("#{file_type}_info", file_path, true)
      uploading_info = fetch_uploading_info(app_info, token)

      app_id      = uploading_info[:id]
      bundle_app  = uploading_info[:bundle][:pkg]
      bundle_icon = uploading_info[:bundle][:icon]

      unless app_info[:icons].empty?
        large_icon_path     = app_info[:icons].max_by { |f| File.size(f) }
        uncrushed_icon_path = convert_icon(large_icon_path)
        upload_app_icon(bundle_icon, uncrushed_icon_path)
      end

      uploaded_info = upload_app_file(bundle_app, file_path)
      version_id    = uploaded_info[:versionOid]
      short         = options[:short].blank? ? uploading_info[:short] : options[:short]

      update_app_info(app_id, name:   app_info[:display_name] || app_info[:name],
                              short:  short,
                              token:  token,
                              source: 'fir-cli')
      update_app_version_info(version_id, version:      app_info[:version],
                                          versionShort: app_info[:short_version],
                                          devices:      app_info[:devices],
                                          release_type: app_info[:release_type],
                                          changelog:    changelog,
                                          token:        token)
      published_app_info = fetch_app_info(app_id, token)

      logger_info_dividing_line
      logger.info "Published succeed: #{api[:base_url]}/#{published_app_info[:short]}"
    end

    private

      def convert_icon origin_path
        logger.info "Converting app's icon......"
        output_path = Tempfile.new('uncrushed_icon.png').path
        Parser.uncrush_icon(origin_path, output_path)
        File.size(output_path) == 0 ? origin_path : output_path
      end

      def upload_app_icon bundle_icon, icon_path
        logger.info "Uploading app's icon......"
        hash = {
          key:   bundle_icon[:key],
          token: bundle_icon[:token],
          file:  File.new(icon_path, 'rb')
        }
        post bundle_icon[:url], hash, 'multipart/form-data'
      end

      def upload_app_file bundle_app, file_path
        logger.info "Uploading app......"
        hash = {
          key:   bundle_app[:key],
          token: bundle_app[:token],
          file:  File.new(file_path, 'rb')
        }
        post bundle_app[:url], hash, 'multipart/form-data'
      end

      def update_app_info id, hash
        logger.info "Updating app info......"
        put api[:app_url] + "/#{id}?#{URI.encode_www_form hash}", hash
      end

      def update_app_version_info id, hash
        logger.info "Updating app's version info......"
        put api[:version_url] + "/#{id}/complete?#{URI.encode_www_form hash}", hash
        put api[:version_url] + "/#{id}?#{URI.encode_www_form hash}", hash
      end

      def fetch_uploading_info app_info, token
        logger.info "Fetching #{app_info[:identifier]}@FIR.im uploading info......"
        get api[:uploading_info_url] + "/#{app_info[:identifier]}", type:  app_info[:type],
                                                                    token: token
      end

      def fetch_app_info id, token
        logger.info "Fetch app info from FIR.im"
        get api[:app_url] + "/#{id}", token: token
      end
  end
end
