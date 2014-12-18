# coding: utf-8
module Fir
  class Cli
    def self.resign_local_options
      option :mobile_provision,
             :aliases => '-m'
      option :sign,
             :aliases => '-s'
    end
    desc 'resign_codesign IPA_FILE_PATH OUTPUT_PATH', '使用 codesign 指令进行签名'
    resign_local_options
    output_options
    def resign_codesign(ipath, opath)
      _chk_os! 'mac'
      _chk_opt! :mobile_provision, :sign
      mp_path, sign_name = _opt :mobile_provision, :sign
      mp_path = _path mp_path
      ipath = _path ipath
      opath = _path opath
      opath += '.ipa' if !opath.to_s.end_with? '.ipa'
      _edit(ipath, opath) do |_d|
        Dir.chdir(_d) do
          apps = Dir['Payload/*.app']
          if apps.length != 1
            _puts "! #{Paint['输入文件不是一个合法的 ipa 文件', :red]}"
            _exit
          end
          app = apps[0]
          _puts "> 替换 mobile provision"
          mp_dest_path = "#{app}/embedded.mobileprovision"
          File.unlink mp_dest_path if File.file? mp_dest_path
          FileUtils.cp mp_path, mp_dest_path
          frmwrk_dir = "#{app}/Frameworks"
          if File.directory? frmwrk_dir
            _puts "> 重签名 dylibs"
            Dir["#{frmwrk_dir}/*.dylib"].each do |_dylib|
              _exec "codesign -f -s \"#{sign_name}\""
            end
          end
          # Dir["Payload/#{app}/*.nib"].each do |_nib|
          #   _exec "codesign -f -s \"#{sign_name}\"
          # end
          # cs_dir = "Payload/#{app}/_CodeSignature"
          # cr_dir = "Payload/#{app}/CodeResources"
          # Dir.rmdir cs_dir if File.directory? cs_dir
          # Dir.rmdir cr_dir if File.directory? cr_dir
          _puts "> 重签名 #{app}"
          _exec "codesign -f -s \"#{sign_name}\" \"#{app}\" --deep"
        end
      end
    end
  end
end

