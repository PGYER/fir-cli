# module Fir
#   class Cli
#     desc 'update APP_FILE_PATH|BUNDLE_ID', '更新 FIR.im 的应用信息'
#     option :short, :aliases => '-s', :desc => '自定义短地址'
#     option :token, :aliases => '-t', :desc => '用户 token'
#     option :verbose, :aliases => '-v', :desc => '设置输出级别 v, vv, vvv'
#     option :quiet, :aliases => '-q', :desc => '安静模式，不输出任何选项'
#     def update(path)
#       identifier = path
#       identifier = _info(path)[:identifier] if File.exist? _path path
#       fir_app = _fir_info identifier
#       opt_short = options[:short]
#       post = {}
#       post[:short] = opt_short if opt_short

#       post.each { |i| post.delete i[0] if i[1] == fir_app[i[0]] }

#       if post.length == 0 then _puts '> 没有什么可以更新的'; return end
#       _fir_put fir_app[:id], post

#       fir_app = _fir_info identifier
#       if opt_short && opt_short != fir_app[:short]
#         _puts "> 短地址 #{opt_short} 被占用，FIR.im 自动更新短地址为 #{fir_app[:short]}"
#       end
#       _puts "> http://fir.im/#{fir_app[:short]}"
#     end
#   end
# end
