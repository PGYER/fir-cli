# encoding: utf-8

require_relative './common'

module FIR
  module Parser
    class Ipa
      include Parser::Common

      def initialize(path)
        @path = path
      end

      def app
        @app ||= App.new(app_path, is_stored)
      end

      def app_path
        @app_path ||= Dir.glob(File.join(contents, 'Payload', '*.app')).first
      end

      def cleanup
        return unless @contents
        FileUtils.rm_rf(@contents)
        @contents = nil
      end

      def metadata
        return unless has_metadata?
        @metadata ||= CFPropertyList.native_types(CFPropertyList::List.new(file: metadata_path).value)
      end

      def has_metadata?
        File.file?(metadata_path)
      end

      def metadata_path
        @metadata_path ||= File.join(@contents, 'iTunesMetadata.plist')
      end

      def is_stored
        has_metadata? ? true : false
      end

      def contents
        return if @contents
        @contents = "#{Dir.tmpdir}/ipa_files-#{Time.now.to_i}"

        Zip::File.open(@path) do |zip_file|
          zip_file.each do |f|
            f_path = File.join(@contents, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          end
        end

        @contents
      end

      class App
        include Parser::Common

        def initialize(path, is_stored = false)
          @path      = path
          @is_stored = is_stored
        end

        def full_info(options)
          if options.fetch(:full_info, false)
            basic_info.merge!(icons: tmp_icons)
          end

          basic_info
        end

        def basic_info
          @basic_info ||= {
            type:              'ios',
            identifier:        identifier,
            name:              name,
            display_name:      display_name,
            build:             version.to_s,
            version:           short_version.to_s,
            devices:           devices,
            release_type:      release_type,
            distribution_name: distribution_name
          }
        end

        def info
          @info ||= CFPropertyList.native_types(
            CFPropertyList::List.new(file: File.join(@path, 'Info.plist')).value)
        end

        def name
          info['CFBundleName']
        end

        def identifier
          info['CFBundleIdentifier']
        end

        def display_name
          info['CFBundleDisplayName']
        end

        def version
          info['CFBundleVersion']
        end

        def short_version
          info['CFBundleShortVersionString']
        end

        def tmp_icons
          icons.map { |data| generate_tmp_icon(data, :ipa) }
        end

        def icons
          @icons ||= begin
            icons = []
            info['CFBundleIcons']['CFBundlePrimaryIcon']['CFBundleIconFiles'].each do |name|
              icons << get_image(name)
              icons << get_image("#{name}@2x")
            end
            icons.delete_if &:!
          rescue NoMethodError
            []
          end
        end

        def mobileprovision
          return unless has_mobileprovision?
          return @mobileprovision if @mobileprovision

          cmd = "security cms -D -i \"#{mobileprovision_path}\""
          begin
            @mobileprovision = CFPropertyList.native_types(CFPropertyList::List.new(data: `#{cmd}`).value)
          rescue CFFormatError
            @mobileprovision = {}
          end
        end

        def has_mobileprovision?
          File.file? mobileprovision_path
        end

        def mobileprovision_path
          @mobileprovision_path ||= File.join(@path, 'embedded.mobileprovision')
        end

        def hide_developer_certificates
          mobileprovision.delete('DeveloperCertificates') if has_mobileprovision?
        end

        def devices
          mobileprovision['ProvisionedDevices'] if has_mobileprovision?
        end

        def distribution_name
          "#{mobileprovision['Name']} - #{mobileprovision['TeamName']}" if has_mobileprovision?
        end

        def release_type
          if @is_stored
            'store'
          else
            if has_mobileprovision?
              if devices
                'adhoc'
              else
                'inhouse'
              end
            end
          end
        end

        private

        def get_image(name)
          path = File.join(@path, "#{name}.png")
          return nil unless File.exist?(path)
          path
        end
      end
    end
  end
end
