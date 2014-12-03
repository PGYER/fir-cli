# coding: utf-8
module Fir
  class Cli
    desc 'publish APP_FILE_PATH', '将应用文件发布至 FIR.im（支持 ipa 文件和 apk 文件）'
    def self.publish_options  
      option :resign, :aliases => '-r', :desc => '设置是否进行企业签名', :type => :boolean
      option :token, :aliases => '-t', :desc => '用户 token'
      option :short, :aliases => '-s', :desc => '自定义短地址'
      option :changelog, :aliases => '-c', :desc => '修改纪录，默认为空字符串', :default => ''
    end
    publish_options
    resign_options
    output_options
    def publish(path)
      if _opt_resign && _is_ipa(path)
        tfile = Tempfile.new ["resign-#{SecureRandom.hex}", '.ipa']
        resign path, tfile.path
        path = tfile.path
      end
      app = _info path, true
      fir_app = _fir_info app[:identifier], app[:type]

      id = fir_app[:id]
      bundle_app = fir_app[:bundle][:pkg]
      bundle_icon = fir_app[:bundle][:icon]
      
      if app[:icons] != nil && app[:icons].length > 0
        icon_path = app[:icons][0][:path]

        if _is_ipa path
          _puts '> 转换图标...'
          Pngdefry.defry icon_path, icon_path
        end

        _puts "> 上传图标..."
        RestClient.post bundle_icon[:url],
                        :key => bundle_icon[:key],
                        :token => bundle_icon[:token],
                        :file => File.new(icon_path, 'rb')

        _puts '> 上传图标成功'
      end

      _puts '> 上传应用...'
      res = RestClient.post bundle_app[:url],
                            :key => bundle_app[:key],
                            :token => bundle_app[:token],
                            :file => File.new(path, 'rb')
      _puts '> 上传应用成功'
      upload_res = JSON.parse res.body, :symbolize_names => true

      _fir_put fir_app[:id],
              :name => app[:display_name] || app[:name],
              :short => options[:short] || fir_app[:short],
              # :desc => options[:describe] || fir_app[:desc]
              # :show => options[:public] || fir_app[:show]
              :source => 'fir-cli'
              
      _fir_vput_complete upload_res[:versionOid],
                         :version => app[:version],
                         :versionShort => app[:short_version],
                         :devices => app[:devices],
                         :release_type => app[:release_type]

      _fir_vput upload_res[:versionOid],
               :changelog => options[:changelog]

      # Get updated app info
      fir_app = _fir_info app[:identifier]
      _puts "> #{_base_path}/#{fir_app[:short]}"
    end
  end
end
