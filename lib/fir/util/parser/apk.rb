# frozen_string_literal: true

require_relative './common'

# Monkey patch to fix illegal character issues in AXML parsing
# Some APKs contain control characters in strings that REXML cannot handle
module Android
  class AXMLParser
    alias_method :original_parse_strings, :parse_strings

    def parse_strings
      original_parse_strings
      # Remove illegal XML control characters from strings
      @strings = @strings.map do |str|
        next str unless str.is_a?(String)
        # Keep only valid XML characters: #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
        str.gsub(/[^\x09\x0A\x0D\x20-\uD7FF\uE000-\uFFFD]/, '')
      end
    end
  end
end

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
        @basic_info ||= begin
          manifest = @apk.manifest
          raise 'Failed to parse AndroidManifest.xml. The APK may be corrupted, repacked, or contain unsupported characters.' unless manifest

          {
            type: 'android',
            name: fetch_label,
            identifier: manifest.package_name,
            build: manifest.version_code.to_s,
            version: manifest.version_name.to_s
          }
        end
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
