# encoding: utf-8

require_relative './util/http'
require_relative './util/config'
require_relative './util/parser/apk'
require_relative './util/parser/ipa'
require_relative './util/parser/pngcrush'
require_relative './util/login'
require_relative './util/me'
require_relative './util/info'
require_relative './util/build_common'
require_relative './util/build_ipa'
require_relative './util/build_apk'
require_relative './util/publish'
require_relative './util/mapping'

module FIR
  module Util
    extend ActiveSupport::Concern

    module ClassMethods
      include FIR::Http
      include FIR::Config
      include FIR::Login
      include FIR::Me
      include FIR::Info
      include FIR::BuildCommon
      include FIR::BuildIpa
      include FIR::BuildApk
      include FIR::Publish
      include FIR::Mapping

      attr_accessor :logger

      def fetch_user_info(token)
        get fir_api[:user_url], api_token: token
      end

      def fetch_user_uuid(token)
        user_info = fetch_user_info(token)
        user_info[:uuid]
      end

      def check_file_exist(path)
        return if File.file?(path)

        logger.error 'File does not exist'
        exit 1
      end

      def check_supported_file(path)
        return if APP_FILE_TYPE.include?(File.extname(path))

        logger.error 'Unsupported file type'
        exit 1
      end

      def check_token_cannot_be_blank(token)
        return unless token.blank?

        logger.error 'Token can not be blank'
      end

      def check_logined
        return unless current_token.blank?

        logger.error 'Please use `fir login` first'
        exit 1
      end

      def logger_info_blank_line
        logger.info ''
      end

      def logger_info_dividing_line
        logger.info '✈ -------------------------------------------- ✈'
      end

      def generate_rqrcode(string, png_file_path)
        qrcode = ::RQRCode::QRCode.new(string.to_s)
        qrcode.as_png(size: 500, border_modules: 2, file: png_file_path)
        png_file_path
      end
    end
  end
end
