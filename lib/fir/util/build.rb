# encoding: utf-8

module FIR
  module Build

    def build_ipa *args, options
      check_osx

      # path = args.first
      p args
      if options.workspace?
      else
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

      def parse_custom_settings *args

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
