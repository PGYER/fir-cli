# frozen_string_literal: true

module FIR
  module Util
    class Publisher
      include FIR::Util

      attr_accessor :args, :options

      def initialize(args, options)
        @file_path     = File.absolute_path(args.first.to_s)
        @file_type     = File.extname(@file_path).delete('.')
        @token         = options[:token] || current_token
        @changelog     = read_changelog(options[:changelog]).to_s.to_utf8
        @short         = options[:short].to_s
        @passwd        = options[:password].to_s
        @is_opened     = @passwd.blank? ? options[:open] : false
        @export_qrcode = !!options[:qrcode]
      end

      private

      def file_path
        @file_path = File.absolute_path(args.first.to_s)
      end

      def read_changelog(changelog)
        return if changelog.blank?

        File.exist?(changelog) ? File.read(changelog) : changelog
      end
    end
  end
end
