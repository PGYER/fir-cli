# encoding: utf-8

module FIR
  module Parser
    module Common

      def generate_tmp_icon data
        tmp_icon_path = "#{Dir.tmpdir}/icon-#{SecureRandom.hex[4..9]}.png"
        File.open(tmp_icon_path, 'w+') { |f| f << data }
        tmp_icon_path
      end
    end
  end
end
