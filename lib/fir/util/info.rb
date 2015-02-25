# encoding: utf-8

module FIR
  module Info

    def info args, options
      file_path = args.first
      is_all    = !!options[:all]

      check_supported_file file_path

      file_type = File.extname(file_path).delete('.')

      logger.info "Analyzing #{file_type} file......"
      logger_info_dividing_line

      app_info  = send("#{file_type}_info", file_path, is_all)
      app_info.each { |k, v| logger.info "#{k}: #{v}" }
    end

    def ipa_info ipa_path, is_all
      ipa = Lagunitas::IPA.new(ipa_path)
      app = ipa.app

      info = {
        type:              'ios',
        identifier:        app.identifier,
        name:              app.bundle_name,
        display_name:      app.display_name,
        version:           app.version,
        short_version:     app.short_version,
        devices:           app.devices,
        release_type:      app.release_type || ipa.release_type,
        distribution_name: app.distribution_name
      }

      if is_all
        app.icons.sort_by { |i| -i[:width] }.each_with_index do |icon, index|
          tmp_icon_path = "/tmp/icon-#{SecureRandom.hex[4..9]}.png"
          FileUtils.cp(icon[:path], tmp_icon_path)
          info["icon_#{index}".to_sym] = tmp_icon_path
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
        type:          'android',
        identifier:    apk.manifest.package_name,
        name:          apk.label,
        version:       apk.manifest.version_code,
        short_version: apk.manifest.version_name
      }

      # apk.icon is a hash, { icon_name: icon_data }
      if is_all
        apk.icon.each_with_index do |name_with_data, index|
          tmp_icon_path = "/tmp/icon-#{SecureRandom.hex[4..9]}.png"
          File.open(tmp_icon_path, 'w+') { |f| f << name_with_data[1] }
          info["icon_#{index}".to_sym] = tmp_icon_path
        end
      end

      info
    end

  end
end
