require 'json'
# require 'byebug'
class FeishuHelper
  attr_accessor :app_info, :options, :feishu_access_token, :qrcode_path, :image_key, :download_url, :title
  include FIR::Config

  def initialize(app_info, options, qrcode_path, download_url)
    @app_info = app_info
    @options = options
    @feishu_access_token = @options[:feishu_access_token]
    @qrcode_path = qrcode_path
    @download_url = download_url

    @title = "#{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]}) #{@app_info[:type]}"
  end

  def send_msg
    return if feishu_access_token.blank?

    answer = v2_request
    v1_request if answer.dig('ok') == 'false'
  end

  def v2_request
    url = "https://open.feishu.cn/open-apis/bot/v2/hook/#{feishu_access_token}"
    x = build_v2_info
    DefaultRest.post(url, x, {timeout: ENV['FEISHU_TIMEOUT'] ? ENV['FEISHU_TIMEOUT'].to_i : 30 })
  end

  def v1_request
    url = "https://open.feishu.cn/open-apis/bot/hook/#{feishu_access_token}"
    payload = {
      "title": "#{title} uploaded",
      "text": "#{title} uploaded at #{Time.now}\nurl: #{download_url}\n#{options[:feishu_custom_message]}\n"
    }
    DefaultRest.post(url, payload, {timeout: ENV['FEISHU_TIMEOUT'] ? ENV['FEISHU_TIMEOUT'].to_i : 30 })
  end

  private

  def build_v2_info
    {
      msg_type: 'post',
      content: {
        post: {
          zh_cn: {
            title: options[:feishu_custom_title] ? options[:feishu_custom_title] : title,
            content: [build_info_tags, [build_image_tag]]
          }
        }
      }
    }
  end

  def build_info_tags
    text = "#{title} uploaded at #{Time.now}\n#{options[:feishu_custom_message]}\n"
    [
      {
        "tag": 'text',
        "text": text
      },
      {
        "tag": 'a',
        "text": download_url,
        "href": download_url
      }
    ]
  end

  def build_image_tag
    {
      "tag": 'img',
      "image_key": upload_qr_code,
      "width": 300,
      "height": 300
    }
  end

  def fetch_image_access_token
    answer = DefaultRest.post(fir_api[:user_feishu_access_token] || 'http://api.appmeta.cn/user/fetch_feishu_v3_token', {})
    answer[:feishu_v3_token]
  end

  def upload_qr_code
    answer = RestClient.post('https://open.feishu.cn/open-apis/image/v4/put/', {
                               image_type: 'message',
                               image: File.new(qrcode_path, 'rb')
                             }, {
                               'Authorization' => "Bearer #{fetch_image_access_token}"
                             })

    json = JSON.parse(answer)
    json.dig('data', 'image_key')
  end
end
