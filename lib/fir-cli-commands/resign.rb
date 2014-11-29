module Fir
  class Cli
    desc 'resign IPA_FILE_PATH OUTPUT_PATH', '使用 resign.tapbeta.com 进行企业签名'
    option :email, :aliases => '-e', :desc => '邮件地址'
    option :verbose, :aliases => '-v', :desc => '设置输出级别 v, vv, vvv'
    option :quiet, :aliases => '-q', :desc => '安静模式，不输出任何选项'
    def resign(ipath, opath)
      _puts "! #{Paint['resign.tapbeta.com 签名服务风险提示', :red]}"
      _puts '! tapbeta 无法保证签名证书的长期有效性，苹果随时可'
      _puts '! 能封杀他们的企业账号，所有由这个企业账号签发的证'
      _puts '! 书都会失效。你如果使用该网站提供的证书进行应用签'
      _puts "! 发，请注意：#{Paint['当证书失效后，所有通过已失效证书签名', :red ]}"
      _puts "! #{Paint['的应用都会无法正常运行；同时托管在 fir.im 的应用', :red ]}"
      _puts "! #{Paint['将无法正常安装。', :red ]}"
      if _opt_email == nil
        @email = _prompt '请输入你的邮件地址：'
        if !@email || @email.length == 0
          _puts "! #{Paint['你需要提供邮件地址才能使用 resign.tapbeta.com 的', :red]}"
          _puts "! #{Paint['签名服务, 请使用', :red]} fir config --email=EMAIL #{Paint['进行设', :red]}"
          _puts "! #{Paint['置', :red]}"
          exit 1
        elsif !_is_email @email
          _puts_invalid_email
          exit 1
        end
      end
      if !_is_ipa ipath
        _puts "! #{Paint['只能给以 ipa 为扩展名的文件签名', :red]}"
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
      #   RestClient.get "#{form[:'notify-url']}?#{URI.encode_www_form JSON.parse res.body}"
      # end


      _puts '> 正在排队...'
      nped = true
      info = {}
      loop do
        res = RestClient.get "http://api.resign.tapbeta.com/public/#{tapbeta[:tb_upload_key]}", 
                             :params => { :__mr => 'eyJ1cmwiOiIkKHVybCkiLCAicmVzaWduU3RhdHVzIjogIiQocmVzaWduU3RhdHVzKSIsICJzdGF0dXMiOiAiJChzdGF0dXMpIn0=' }
        info = JSON.parse res.body, :symbolize_names => true
        if nped && info[:resignStatus] == 'doing'
          _puts '> 正在签名...'
          nped = false
        end
        if info[:status] == 'error'
          _puts "! #{Paint['签名失败', :red]}"
          exit 1
        end
        break if info[:url] != ''
        sleep 5
      end
      opath = Pathname.new(Dir.pwd).join(opath).cleanpath
      _puts "> 正在下载到 #{opath}..."
      `curl #{info[:url]} -o #{opath} -s`
    end
  end
end

