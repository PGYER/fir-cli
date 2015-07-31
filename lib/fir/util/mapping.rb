# encoding: utf-8

module FIR
  module Mapping

    def mapping *args, options
      @file_path = File.absolute_path(args.first.to_s)
      @token     = options[:token] || current_token

      check_token_cannot_be_blank(@token)

      @p_id    = options[:project_id].to_s
      @version = options[:version].to_s
      @build   = options[:build].to_s
      @uuid    = fetch_user_uuid(@token)

      logger.info "Creating bughd project's version......."
      logger_info_dividing_line

      @full_version = find_or_create_bughd_full_version

      logger.info "Uploading mapping file......."
      logger_info_dividing_line

      upload_mapping_file

      logger.info "Uploaded succeed: #{bughd_api[:domain]}/project/#{@p_id}/settings"
    end

    def find_or_create_bughd_full_version
      url = bughd_api[:project_url] + "/#{@p_id}/full_versions"
      post url, version: @version, build: @build
    end

    def upload_mapping_file
      full_version_id = @full_version[:id]

      # convert mapping_file txt or dSYM(find dSYM)
    end
  end
end
