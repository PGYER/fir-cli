require 'lagunitas'
module Lagunitas
  class App
    def initialize(path, root)
      @path = path
      @root = root
    end
    def icons
      icons = []
      info['CFBundleIcons']['CFBundlePrimaryIcon']['CFBundleIconFiles'].each do |name|
        icons << get_image(name)
        icons << get_image("#{name}.png")
        icons << get_image("#{name}@2x.png")
        icons << get_image("#{name}@3x.png")
      end
      icons.delete_if { |i| !i }
    rescue
      nil
    end
    def get_image(name)
      path = File.join @path, name
      return nil unless File.file? path
      dimensions = Pngdefry.dimensions(path)
      {
        path: path,
        width: dimensions.first,
        height: dimensions.last
      }
    rescue Errno::ENOENT
      nil
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
            zip_file.extract f, f_path unless File.file? f_path
          end
        end
        tmp_path
      end
    end
  end
end
