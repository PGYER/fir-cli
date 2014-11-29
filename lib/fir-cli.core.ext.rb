module Fir
  class Cli
    private
    def _fir_info(identifier, type = 'ios')
      _puts "> 正在获取 #{identifier}@FIR.im 的应用信息..."
      _chk_login
      body = { :token => @token, :type => type }
      res = RestClient.get "http://fir.im/api/v2/app/info/#{identifier}?#{URI.encode_www_form body}"
      JSON.parse res.body, :symbolize_names => true
    end
    def _fir_put(id, body)
      _chk_login
      body[:token] = @token
      _puts '> 正在更新 fir 的应用信息...'
      RestClient.put "http://fir.im/api/v2/app/#{id}?#{URI.encode_www_form body}", body
      _puts '> 更新成功'
    end
    def _fir_vput_complete(id, body)
      _chk_login
      body[:token] = @token
      _puts '> 正在更新 fir 的应用版本信息...'
      RestClient.put "http://fir.im/api/v2/appVersion/#{id}/complete?#{URI.encode_www_form body}", body
      _puts '> 更新成功'
    end
    def _fir_vput(id, body)
      _chk_login
      body[:token] = @token
      RestClient.put "http://fir.im/api/v2/appVersion/#{ id }?#{ URI.encode_www_form body }", body
    end
    def _user(token)
      RestClient.get "http://fir.im/api/v2/user/me?token=#{token}" do |res|
        case res.code
        when 200
          JSON.parse res.body, :symbolize_names => true
        else
          nil
        end
      end
    end
  end
end
