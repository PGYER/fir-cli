# coding: utf-8
module Fir
  class Cli
    private
    def _fir_url
      @base_path ||= begin
        path = @config['base_path'] || 'http://fir.im'
        path = path.strip
        path = path.end_with?('/') ? path.chop : path
      end
    end
    def _fir_info(identifier, type = 'ios')
      _puts "> 正在获取 #{identifier}@FIR.im 的应用信息..."
      _chk_login!
      body = { :token => @token, :type => type }
      res = RestClient.get "#{_fir_url}/api/v2/app/info/#{identifier}?#{URI.encode_www_form body}"
      JSON.parse res.body, :symbolize_names => true
    end
    def _fir_put(id, body)
      _chk_login!
      body[:token] = @token
      _puts '> 正在更新 fir 的应用信息...'
      RestClient.put "#{_fir_url}/api/v2/app/#{id}?#{URI.encode_www_form body}", body
      _puts '> 更新成功'
    end
    def _fir_vput_complete(id, body)
      _chk_login!
      body[:token] = @token
      _puts '> 正在更新 fir 的应用版本信息...'
      RestClient.put "#{_fir_url}/api/v2/appVersion/#{id}/complete?#{URI.encode_www_form body}", body
      _puts '> 更新成功'
    end
    def _fir_vput(id, body)
      _chk_login!
      body[:token] = @token
      RestClient.put "#{_fir_url}/api/v2/appVersion/#{id}?#{URI.encode_www_form body}", body
    end
    def _user(token)
      RestClient.get "#{_fir_url}/api/v2/user/me?token=#{token}" do |res|
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
