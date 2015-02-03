# # coding: utf-8
# module Fir
#   class Cli
#     def self.resign_options
#       option :resign_type,
#              :desc => '选择使用哪种方式进行重签名，默认使用 tapbeta'
#       resign_tapbeta_options
#       resign_local_options
#     end
#     desc 'resign ORIGINAL_IPA OUTPUT_IPA [--resign-type=codesign]', '使用指定类型的签名方式'
#     resign_options
#     output_options
#     def resign(ipath, opath)
#       if !options[:resign_type]
#         resign_tapbeta ipath, opath
#       else
#         begin
#           method("resign_#{options[:resign_type]}".to_sym).call ipath, opath
#         rescue NameError => e
#           _puts "! #{Paint["没有 resign_#{options[:resign_type]} 的重签名方式"]}"
#         end
#       end
#     end
#   end
# end

