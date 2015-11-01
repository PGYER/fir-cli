# encoding: utf-8

module FIR
  module Parser
    module Common

      # when type is ipa, the icon data is a png file.
      # when type is apk, the icon data is a binary data.
      def generate_tmp_icon data, type
        tmp_icon_path = "#{Dir.tmpdir}/icon-#{SecureRandom.hex[4..9]}.png"

        if type == :ipa
          FileUtils.cp(data, tmp_icon_path)
        elsif type == :apk
          File.open(tmp_icon_path, 'w+') { |f| f << data }
        else
          return
        end

        tmp_icon_path
      end
    end
  end
end
