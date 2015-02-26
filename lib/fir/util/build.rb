# encoding: utf-8

module FIR
  module Build

    def build_ipa *args, options
      check_osx

      path     = File.absolute_path(args.shift)
      settings = parse_custom_settings(*args)

      if options.workspace?
        check_workspace
      else
        check_project
      end

    end

    def build_apk *args, options
    end

    private

      def check_osx
        unless OS.mac?
          logger.error "Unsupported OS type, `build_ipa` only support for OSX"
        end
      end

      def check_project path
      end

      def check_workspace path
      end

      def parse_custom_settings *args
        hash = {}
        args.each do |setting|
          k, v = setting.split('=', 2).map(&:strip)
          hash[k.to_sym] = v
        end
        hash
      end

    def zip_app2ipa app_path, ipa_path
      # Dir.mktmpdir do |tmpdir|
      #   Dir.chdir(tmpdir) do
      #     Dir.mkdir "Payload"
      #     FileUtils.cp_r app_path, 'Payload'
      #     system("rm -rf #{ipa_path}") if File.file? ipa_path
      #     _puts "> 正在打包 app： #{File.basename app_path} 到 #{ipa_path}"
      #     _exec "zip -qr #{ipa_path} Payload"
      #   end
      # end
    end
  end
end
