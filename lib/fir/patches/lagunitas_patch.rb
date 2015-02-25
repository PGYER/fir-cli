# encoding: utf-8

module Lagunitas

  class IPA

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
  end

  class App

    # TODO: remove when https://github.com/soffes/lagunitas/pull/3 merged
    def icons
      @icons ||= begin
        icons = []
        info['CFBundleIcons']['CFBundlePrimaryIcon']['CFBundleIconFiles'].each do |name|
          icons << get_image(name)
          icons << get_image("#{name}@2x")
        end
        icons.delete_if { |i| !i }
      rescue NoMethodError # fix a ipa without icons
        []
      end
    end

    def bundle_name
      info['CFBundleName']
    end

    def mobileprovision
      return unless has_mobileprovision?
      return unless OS.mac?

      @mobileprovision ||= CFPropertyList.native_types(
        CFPropertyList::List.new(data: `security cms -D -i "#{mobileprovision_path}"`).value
      )
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

  end
end
