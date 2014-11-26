module Fir
  class Cli < Thor    
    desc 'resign IPA_FILE_PATH OUTPUT_PATH', '使用 resign.tapbeta.com 进行企业签名'
    option :email, :aliases => '-e', :desc => '邮件地址'
    option :verbose, :aliases => '-v', :desc => '设置输出级别 v, vv, vvv'
    option :quiet, :aliases => '-q', :desc => '安静模式，不输出任何选项'
    def resign(ipath, opath)
      _puts "! #{ Paint['resign.tapbeta.com 签名服务风险提示', :red] }"
      _puts '! 无法保证签名证书的长期有效性，当某种条件满足后'
      _puts '! 苹果会禁止该企业账号，所有由该企业账号所签发的'
      _puts '! 证书都会失效。您如果使用该网站提供的服务进行应'
      _puts "! 用分发，请注意：#{ Paint['当证书失效后，所有安装了已失效', :red ] }"
      _puts "! #{ Paint['证书签名的用户都会无法正常运行应用；同时托管在', :red ] }"
      _puts "! #{ Paint['fir.im 的应用将无法正常安装。', :red ] }"
      if _opt_email == nil
        @email = _prompt '请输入您的邮件地址：'
        if !@email || @email.length == 0
          _puts "! #{ Paint['您需要提供邮件地址才能使用 resign.tapbeta.com', :red] }"
          _puts "! #{ Paint['的签名服务, 请输入:', :red] } fir config --email=EMAIL"
          _puts "! #{ Paint['进行设置', :red] }"
          exit 1
        elsif !_is_email @email
          _puts "! #{ Paint['您输入的邮件地址不合法', :red] }"
          exit 1
        end
      end
      if !/\.ipa$/.match ipath
        _puts Paint['! 只能给以 ipa 为扩展名的文件签名', :red]
        exit 1
      end
      _puts '> 正在申请上传令牌...'
      upload_res = RestClient.post 'http://api.resign.tapbeta.com/public/upload',
                                   :email => @email,
                                   :file => File.basename(ipath)
      form = JSON.parse upload_res.body, :symbolize_names => true
      tapbeta = {}
      form.each do |f|
        if /^tb_/.match f[0]
          tapbeta[f[0]] = f[1]
          form.delete f[0]
        end
      end
      form[:file] = File.new Pathname.new(Dir.pwd).join(ipath).cleanpath, 'rb'
      _puts '> 正在上传...'
      res = RestClient.post tapbeta[:tb_upload_url], form

      # Upyun's notify is fucking, handle it specific
      # if tapbeta[:tb_upload_url].include? 'upyun'
      #   RestClient.get "#{ form[:'notify-url'] }?#{ URI.encode_www_form JSON.parse res.body }"
      # end


      _puts '> 正在排队...'
      nped = true
      info = {}
      loop do
        res = RestClient.get "http://api.resign.tapbeta.com/public/#{ tapbeta[:tb_upload_key] }", 
                             :params => { :__mr => 'eyJ1cmwiOiIkKHVybCkiLCAicmVzaWduU3RhdHVzIjogIiQocmVzaWduU3RhdHVzKSJ9' }
        info = JSON.parse res.body, :symbolize_names => true
        if nped && info[:resignStatus] == 'doing'
          _puts '> 正在签名...'
          nped = false
        end
        break if info[:url] != ''
        sleep 5
      end
      opath = Pathname.new(Dir.pwd).join(opath).cleanpath
      _puts "> 正在下载到 #{ opath }..."
      `curl #{ info[:url] } -o #{ opath } -s`
    end
  end
end

