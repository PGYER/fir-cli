# encoding: utf-8

module FIR
  module PublishApp

    def publish_app args, options
      file_path = args.first
      token     = options[:token] || current_token

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

      if largest_icon_path = app_info[:icon_0]
        # convert_icon(largest_icon_path, largest_icon_path) if file_type == 'ipa'
        upload_app_icon(bundle_icon, largest_icon_path)
      end

      uploaded_info = upload_app_file(bundle_app, file_path)
      version_id    = uploaded_info[:versionOid]

      update_app_info(app_id, name:   app_info[:name],
                              short:  options[:short] || uploading_info[:short],
                              token:  token,
                              source: 'fir-cli')
      update_app_version_info(version_id, version:      app_info[:version],
                                          versionShort: app_info[:short_version],
                                          devices:      app_info[:devices],
                                          release_type: app_info[:release_type],
                                          changelog:    options[:changelog],
                                          token:        token)
      published_app_info = fetch_app_info(app_id, token)

      logger_info_dividing_line
      logger.info "Published succeed: #{api[:base_url]}/#{published_app_info[:short]}"
    end

  private

    def convert_icon origin_path, output_path
      logger.info "Converting icon......"
      Pngdefry.defry(origin_path, output_path)
      output_path
    end

  end
end
