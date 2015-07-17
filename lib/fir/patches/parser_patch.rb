# encoding: utf-8

module Parser

  class << self

    def png_bin
      @png_bin ||= File.expand_path("../bin/pngcrush", __FILE__)
    end

    def uncrush_icon crushed_icon_path, uncrushed_icon_path
      system("#{png_bin} -revert-iphone-optimizations #{crushed_icon_path} #{uncrushed_icon_path} &> /dev/null")
    end

    def crush_icon uncrushed_icon_path, crushed_icon_path
      system("#{png_bin} -iphone #{uncrushed_icon_path} #{crushed_icon_path} &> /dev/null")
    end
  end

  class IPA

    def initialize(path)
      @path = path
    end

    def app
      @app ||= App.new(app_path)
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
      File.file? metadata_path
    end

    def metadata_path
      @metadata_path ||= File.join(@contents, 'iTunesMetadata.plist')
    end

    def release_type
      has_metadata? ? 'store' : 'adhoc'
    end

    private

      def contents
        return if @contents
        @contents = "fir-cli_tmp/ipa_files-#{Time.now.to_i}"

        Zip::File.open(@path) do |zip_file|
          zip_file.each do |f|
            f_path = File.join(@contents, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          end
        end

        @contents
      end
  end

  class App

    def initialize(path)
      @path = path
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

    def icons
      @icons ||= begin
        icons = []
        info['CFBundleIcons']['CFBundlePrimaryIcon']['CFBundleIconFiles'].each do |name|
          icons << get_image(name)
          icons << get_image("#{name}@2x")
        end
        icons.delete_if { |i| !i }
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
      if has_mobileprovision?
        if devices
          'adhoc'
        else
          'inhouse'
        end
      end
    end

    private

      def get_image name
        path = File.join(@path, "#{name}.png")
        return nil unless File.exist?(path)
        path
      end
  end
end
