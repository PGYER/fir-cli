# encoding: utf-8

module FIR
  module Parser
    class Apk
      def initialize(path)
        @apk = ::Android::Apk.new(path)
      end

      def full_info(options)
        if options.fetch(:full_info, false)
          basic_info.merge!(icons: tmp_icons)
        end

        basic_info
      end

      def basic_info
        @basic_info ||= {
          type:       'android',
          identifier: @apk.manifest.package_name,
          name:       @apk.label,
          build:      @apk.manifest.version_code.to_s,
          version:    @apk.manifest.version_name.to_s
        }
      end

      # @apk.icon is a hash, { icon_name: icon_data }
      def tmp_icons
        @apk.icon.map do |_, data|
          tmp_icon_path = "#{Dir.tmpdir}/icon-#{SecureRandom.hex[4..9]}.png"
          File.open(tmp_icon_path, 'w+') { |f| f << data }
          tmp_icon_path
        end
      end
    end
  end
end
