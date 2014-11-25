require 'lagunitas'
module Lagunitas
  class App
    def initialize(path, root)
      @path = path
      @root = root
    end
    def icons
      @icons ||= begin
        icons = []
        info['CFBundleIcons']['CFBundlePrimaryIcon']['CFBundleIconFiles'].each do |name|
          icons << get_image(name)
          icons << get_image("#{name}@2x")
        end
        icons.delete_if { |i| !i }
      rescue
        # info['CFBundleIcons'] might be nil
        nil
      end
    end
  end
  class IPA
    def app
      @app ||= App.new app_path, root_path
    end
    def contents
      @contents ||= begin
        tmp_path = "tmp/lagunitas-#{SecureRandom.hex}"
        Zip::ZipFile.open @path do |zip_file|
          zip_file.each do |f|
            f_path = File.join tmp_path, f.name
            FileUtils.mkdir_p File.dirname f_path
            zip_file.extract f, f_path unless File.exist? f_path
          end
        end
        tmp_path
      end
    end
  end
end
