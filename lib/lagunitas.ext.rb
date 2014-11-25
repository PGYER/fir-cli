require 'cfpropertylist'
require 'lagunitas'
module Lagunitas
  class App
    def initialize(path, root)
      @path = path
      @root = root
    end
    def name
      @info['CFBundleName']
    end
    def mobileprovision
      return if !mobileprovision?
      @mobileprovision ||= CFPropertyList.native_types CFPropertyList::List.new(:data => `security cms -D -i #{File.join @path, 'embedded.mobileprovision'}`).value
    end
    def mobileprovision?
      return true if @mobileprovision
      File.exists? File.join @path, 'embedded.mobileprovision'
    end
    def devices
      mobileprovision['ProvisionedDevices'] if mobileprovision
    end
    def distribution_name
      # mobileprovision['DeveloperCertificates'] if mobileprovision
      "#{ mobileprovision['Name'] }: #{ mobileprovision['TeamName'] }" if mobileprovision
    end
    def metadata
      return if !metadata?
      @metadata ||= CFPropertyList.native_types(CFPropertyList::List.new(file: File.join(@root, 'iTunesMetadata.plist')).value)
    end
    def metadata?
      return true if @metadata
      File.exists? File.join @root, 'iTunesMetadata.plist'
    end
    def release_type
      @release_type ||= begin
        if mobileprovision?
          if devices
            'adhoc'
          else
            'inhouse'
          end
        elsif metadata?
          'store'
        else
          'adhoc'
        end
      end
    end
  end
  class IPA
    def root_path
      contents
    end
  end
end
