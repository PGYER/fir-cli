# frozen_string_literal: true

require_relative './common'
module FIR
  module Parser
    class Apk
      include Parser::Common

      def initialize(path)
        Zip.warn_invalid_date = false
        @apk = ::Android::Apk.new(path)
      end

      def full_info(options)
        basic_info[:icons] = tmp_icons if options.fetch(:full_info, false)

        basic_info
      end

      def basic_info
        @basic_info ||= {
          type: 'android',
          name: fetch_label,
          identifier: @apk.manifest.package_name,
          build: @apk.manifest.version_code.to_s,
          version: @apk.manifest.version_name.to_s
        }
        @basic_info.reject! { |_k, v| v.nil? }
        @basic_info
      end

      # @apk.icon is a hash, { icon_name: icon_binary_data }
      def tmp_icons
        @apk.icon.map { |_, data| generate_tmp_icon(data, :apk) }
      rescue StandardError
        []
      end

      def fetch_label
        @apk.label
      rescue NoMethodError
        nil
      end
    end
  end
end
