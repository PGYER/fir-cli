# encoding: utf-8

module FIR
  module BuildIPA

    def build_ipa args, options
      check_osx

    end

    private

      def check_osx
        unless OS.mac?
          logger.info "Unsupported OS type"
        end
      end
  end
end
