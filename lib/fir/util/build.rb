# encoding: utf-8

module FIR
  module Build

    def build args, options
      check_osx

    end

    def build_ipa args, options
    end

    def build_apk args, options
    end

    private

      def check_osx
        unless OS.mac?
          logger.info "Unsupported OS type"
        end
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
