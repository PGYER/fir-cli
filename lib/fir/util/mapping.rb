# encoding: utf-8

module FIR
  module Mapping

    def mapping *args, options
      @file_path = File.absolute_path(args.first.to_s)
      @token     = options[:token] || current_token
      @proj      = options[:proj].to_s
      @version   = options[:version].to_s
      @build     = options[:build].to_s

      check_file_exist @file_path
      check_token_cannot_be_blank @token
      check_project_id_cannot_be_blank

      logger.info "Creating bughd project's version......."
      logger_info_dividing_line

      @full_version = find_or_create_bughd_full_version

      logger.info "Uploading mapping file......."
      logger_info_dividing_line

      upload_mapping_file

      logger.info "Uploaded succeed: #{bughd_api[:domain]}/project/#{@proj}/settings"
      logger_info_blank_line
    end

    def find_or_create_bughd_full_version
      url = bughd_api[:project_url] + "/#{@proj}/full_versions"
      post url, version: @version, build: @build, uuid: uuid
    end

    def upload_mapping_file
      if File.is_dsym?(@file_path)
        tmp_file_path = "#{Dir.tmpdir}/mapping-#{SecureRandom.hex[4..9]}.dSYM"
        FileUtils.cp(@file_path, tmp_file_path)
      elsif File.is_txt?(@file_path)
        tmp_file_path = "#{Dir.tmpdir}/mapping-#{SecureRandom.hex[4..9]}.txt"
        FileUtils.cp(@file_path, tmp_file_path)
      else
        tmp_file_path = @file_path
      end

      url = bughd_api[:full_version_url] + "/#{@full_version[:id]}"
      patch url, file: File.new(tmp_file_path, 'rb'), uuid: uuid
    end

    private

      def check_project_id_cannot_be_blank
        if @proj.blank?
          logger.error "Project id can't be blank"
          exit 1
        end
      end

      def uuid
        @uuid ||= fetch_user_uuid(@token)
      end

  end
end
