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

      upload_mapping_file
      logger_info_dividing_line

      logger.info "Uploaded succeed: #{bughd_api[:domain]}/project/#{@proj}/settings"
      logger_info_blank_line
    end

    def find_or_create_bughd_full_version
      url = bughd_api[:project_url] + "/#{@proj}/full_versions"
      post url, version: @version, build: @build, uuid: uuid
    end

    def upload_mapping_file
      tmp_file_path = rename_and_zip_mapping_file

      url = bughd_api[:full_version_url] + "/#{@full_version[:id]}"
      patch url, file: File.new(tmp_file_path, 'rb'), project_id: @proj, uuid: uuid
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

      def rename_and_zip_mapping_file
        tmp_file_path = "#{Dir.tmpdir}/#{File.basename(@file_path)}-fircli"
        FileUtils.cp(@file_path, tmp_file_path)

        mapping_file_size = File.size?(tmp_file_path)

        logger.info "Mapping file size - #{mapping_file_size}"

       if mapping_file_size > 50*1000*1000
          logger.info "Zipping mapping file......."

          system("zip -qr #{tmp_file_path}.zip #{tmp_file_path}")

          tmp_file_path = tmp_file_path + '.zip'

          logger.info "Zipped Mapping file size - #{File.size?(tmp_file_path)}"
        end

        if File.is_dsym?(@file_path)
          FileUtils.mv(tmp_file_path, tmp_file_path + '.dSYM')
          tmp_file_path = tmp_file_path + '.dSYM'
        elsif File.is_txt?(@file_path)
          FileUtils.mv(tmp_file_path, tmp_file_path + '.txt')
          tmp_file_path = tmp_file_path + '.txt'
        end

        tmp_file_path
      end

  end
end
