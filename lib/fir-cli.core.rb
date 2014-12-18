# coding: utf-8
module Fir
  class Cli
    def initialize(*args)
      super
      @tmpfiles = []
      _init_config
      _load_config
      _puts_welcome
    end
    private
    def _info(path, more = false)
      if _is_ipa? path
        _ipa_info path, more
      elsif _is_apk? path
        _apk_info path, more
      else
        _puts "! #{Paint['只能支持后缀为 ipa 和 apk 的文件', :red]}"
        _exit
      end
    end
    def _apk_info(path, more = false)
      path = _path path
      apk = Android::Apk.new path
      info = {
        :type => 'android',
        :identifier => apk.manifest.package_name,
        :name => apk.label,
        :version => apk.manifest.version_code,
        :short_version => apk.manifest.version_name
      }
      if more
        info[:icons] = apk.icon.map do |name, data|
          tfile = Tempfile.new ["icon-#{SecureRandom.hex}", '.png']
          tfile.write data
          @tmpfiles.push tfile
          {
            :name => File.basename(name),
            :path => tfile.path
          }
        end
      end
      info
    end
    def _ipa_info(path, more = false)
      path = _path path
      ipa = Lagunitas::IPA.new path
      _puts '> 正在解析 ipa 文件...'
      app = ipa.app
      info = {
        :type => 'ios',
        :identifier => app.identifier,
        :name => app.name,
        :display_name => app.display_name,
        :version => app.version,
        :short_version => app.short_version,
        :devices => app.devices,
        :release_type => app.release_type,
        :distribution_name => app.distribution_name
      }
      if more
        if app.icons
          info[:icons] = app.icons.sort { |a,b| -(a[:width] <=> b[:width]) }.map do |icon|
            tfile = Tempfile.new ["icon-#{SecureRandom.hex}", '.png']
            @tmpfiles.push tfile
            FileUtils.cp icon[:path], tfile.path
            {
              :name => File.basename(icon[:path]),
              :path => tfile.path
            }
          end
        end
        info[:plist] = app.info
        app.mobileprovision.delete 'DeveloperCertificates' if app.mobileprovision
        info[:mobileprovision] = app.mobileprovision
      end
      ipa.cleanup
      info
    end
    def _batch_publish(*dirs)
      _puts "! #{ Paint['至少需要提供一个文件夹', :red] }" if dirs.length == 0
      dirs.each do |dir|
        Dir.foreach(dir) do |_f|
          if _is_ipa?(_f) || _is_apk?(_f)
            _puts "> 正在发布 #{ _f }"
            begin
              publish File.join dir, _f
            # rescue Exception => e
            #   _puts "! #{ _f } 失败：#{ e.to_s }"
            end
          end
        end
      end
    end
  end
end
