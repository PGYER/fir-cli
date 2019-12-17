# encoding: utf-8

module FIR
  module Info

    def info(*args, options)
      file_path = File.absolute_path(args.first.to_s)
      is_all    = !options[:all].blank?

      check_file_exist file_path
      check_supported_file file_path

      file_type = File.extname(file_path).delete('.')

      logger.info "Analyzing #{file_type} file......"
      logger_info_dividing_line

      app_info = send("#{file_type}_info", file_path, full_info: is_all)
      app_info.each { |k, v| logger.info "#{k}: #{v}" }

      logger_info_blank_line
    end

    def ipa_info(ipa_path, options = {})
      ipa  = FIR::Parser::Ipa.new(ipa_path)
      app  = ipa.app
      info = app.full_info(options)
      ipa.cleanup
      info[:file_path] = ipa_path
      info
    end

    def aab_info(aab_path, options = {})
      bundletool_jar_path = options[:bundletool_jar_path]
      auto_download_bundletool_jar = options[:auto_download_bundletool_jar] || false
      s = FIR::Parser::AabAnalysis.new(aab_path, bundletool_jar_path, auto_download_bundletool_jar)
      info = s.info
      info[:file_path] = aab_path
      info
    end

    def apk_info(apk_path, options = {})
      apk  = FIR::Parser::Apk.new(apk_path)
      info = apk.full_info(options)
      info[:file_path] = apk_path
      info
    end
  end
end
