# encoding: utf-8

require_relative './util/app_info'
require_relative './util/build_ipa'
require_relative './util/publish_app'

module FIR
  module Util

    def self.included base
      base.extend ClassMethods
      base.extend AppInfo
      base.extend BuildIPA
      base.extend PublishApp
    end

    module ClassMethods

      def login token
        check_token_cannot_be_blank token

        user_info = fetch_user_info(token)

        logger.info "Login succeed, previous user's email: #{config[:email]}" unless config.blank?
        write_config(email: user_info.fetch(:email, ''), token: user_info.fetch(:token, ''))
        reload_config
        logger.info "Login succeed, current  user's email: #{config[:email]}"
      end

      def fetch_user_info token
        get api[:me_url], token: token
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

      private

        def check_supported_file path
          path = path.to_s
          unless File.file?(path) || APP_FILE_TYPE.include?(File.extname(path))
            logger.error "File does not exist or unsupported file type"
            exit 1
          end
        end

        def check_token_cannot_be_blank token
          if token.blank?
            logger.error "Token can't be blank"
            exit 1
          end
        end

        def logger_info_dividing_line
          logger.info "✈ -------------------------------------------- ✈"
        end
    end

  end
end
