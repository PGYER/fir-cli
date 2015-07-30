# encoding: utf-8

module FIR
  module Mapping

    def mapping *args, options
      token = options[:token] || current_token
      check_token_cannot_be_blank(token)

      @project_id = options[:project_id].to_s
      @version    = options[:version].to_s
      @build      = options[:build].to_s
      @uuid       = fetch_user_uuid(token)

      logger.info "Creating bughd project's version......."
      logger_info_dividing_line

      find_or_create_bughd_full_version

      logger.info "Uploading mapping file......."
      logger_info_dividing_line

      upload_mapping_file

      logger.info "Uploaded succeed: #{bughd_api[:domain]}/project/#{@project_id}/settings"
    end

    def find_or_create_bughd_full_version
      res = post(bughd_api[:project_url] + "/#{@project_id}/full_versions",
                 version: @version,
                 build:   @build)


    end

    def upload_mapping_file
    end
  end
end
