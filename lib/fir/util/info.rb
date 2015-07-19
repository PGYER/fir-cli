# encoding: utf-8

module FIR
  module Info

    def info *args, options
      file_path = File.absolute_path(args.first.to_s)
      is_all    = !options[:all].blank?

      check_supported_file file_path

      file_type = File.extname(file_path).delete('.')

      logger.info "Analyzing #{file_type} file......"
      logger_info_dividing_line

      app_info  = send("#{file_type}_info", file_path, is_all)
      app_info.each { |k, v| logger.info "#{k}: #{v}" }
    end

    def ipa_info ipa_path, is_all
      ipa = Parser::IPA.new(ipa_path)
      app = ipa.app

      info = {
        type:              'ios',
        identifier:        app.identifier,
        name:              app.name,
        display_name:      app.display_name,
        build:             app.version.to_s,
        version:           app.short_version.to_s,
        devices:           app.devices,
        release_type:      app.release_type || ipa.release_type,
        distribution_name: app.distribution_name
      }

      if is_all
        info[:icons] = []
        app.icons.each do |icon|
          tmp_icon_path = "#{Dir.tmpdir}/icon-#{SecureRandom.hex[4..9]}.png"
          FileUtils.cp(icon, tmp_icon_path)
          info[:icons] << tmp_icon_path
        end

        app.hide_developer_certificates

        info[:plist]           = app.info
        info[:mobileprovision] = app.mobileprovision
      end

      ipa.cleanup
      info
    end

    def apk_info apk_path, is_all
      apk  = Android::Apk.new(apk_path)
      info = {
        type:       'android',
        identifier: apk.manifest.package_name,
        name:       apk.label,
        build:      apk.manifest.version_code.to_s,
        version:    apk.manifest.version_name.to_s
      }

      # apk.icon is a hash, { icon_name: icon_data }
      if is_all
        info[:icons] = []
        apk.icon.each do |name, data|
          tmp_icon_path = "#{Dir.tmpdir}/icon-#{SecureRandom.hex[4..9]}.png"
          File.open(tmp_icon_path, 'w+') { |f| f << data }
          info[:icons] << tmp_icon_path
        end
      end

      info
    end
  end
end
