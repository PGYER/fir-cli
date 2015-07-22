# encoding: utf-8

require_relative './util/login'
require_relative './util/me'
require_relative './util/info'
require_relative './util/build'
require_relative './util/publish'

module FIR
  module Util

    def self.included base
      base.extend ClassMethods
      base.extend Login
      base.extend Me
      base.extend Info
      base.extend Build
      base.extend Publish
    end

    module ClassMethods

      def fetch_user_info token
        get api[:user_url], api_token: token
      end

      def check_supported_file path
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

      def check_logined
        if current_token.blank?
          logger.error "Please use `fir login` first"
          exit 1
        end
      end

      def logger_info_dividing_line
        logger.info "✈ -------------------------------------------- ✈"
      end
    end
  end
end
