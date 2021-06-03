require 'json'
require 'openssl'
require 'base64'
require 'cgi'
# require 'byebug'
class DingtalkHelper
  attr_accessor :app_info, :options, :access_token, :qrcode_path, :image_key, :download_url, :title
  include FIR::Config

  def initialize(app_info, options, qrcode_path, download_url)
    @app_info = app_info
    @options = options
    @access_token = @options[:dingtalk_access_token]
    @secret = @options[:dingtalk_secret]
    @qrcode_path = qrcode_path
    @download_url = download_url
  end

  def send_msg
    return if options[:dingtalk_access_token].blank?

    api_domain = @app_info[:api_url]
    title = "#{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]}) #{@app_info[:type]}"
    payload = {
      "msgtype": 'markdown',
      "markdown": {
        "title": "#{title} uploaded",
        "text": "#### #{title}\n\n>uploaded at #{Time.now}\n\nurl: #{download_url}\n\n#{options[:dingtalk_custom_message]}\n\n ![](#{api_domain}/welcome/qrcode?url=#{download_url})"
      }
    }
    build_dingtalk_at_info(payload)
    url = "https://oapi.dingtalk.com/robot/send?access_token=#{options[:dingtalk_access_token]}"
    if options[:dingtalk_secret]
      info = secret_cal(options[:dingtalk_secret])
      url = "#{url}&timestamp=#{info[:timestamp]}&sign=#{info[:sign]}"
    end

    x = DefaultRest.post(url, payload)
  rescue StandardError => e
  end

  def build_dingtalk_at_info(payload)
    answer = {}
    answer[:isAtAll] = options[:dingtalk_at_all]

    unless options[:dingtalk_at_phones].blank?
      answer[:atMobiles] = options[:dingtalk_at_phones].split(',')
      payload[:markdown][:text] += options[:dingtalk_at_phones].split(',').map { |x| "@#{x}" }.join(',')
    end

    payload[:at] = answer
  end

  def secret_cal(secret)
    timestamp = Time.now.to_i * 1000
    secret_enc = secret.encode('utf-8')
    str = "#{timestamp}\n#{secret}"
    string_to_sign_enc = str.encode('utf-8')

    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret_enc, string_to_sign_enc)
    {
      timestamp: timestamp,
      sign: CGI.escape(Base64.encode64(hmac).strip)
    }

  end
end
