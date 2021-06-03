module FIR
  module ThirdNotifierModule
    def notify_to_thirds(download_url, qrcode_path)
      dingtalk_notifier(download_url, qrcode_path)
      feishu_notifier(download_url, qrcode_path)
      wxwork_notifier(download_url)
    rescue => e
      logger.warn "third notifiers error #{e.message}"
    end

    def dingtalk_notifier(download_url, qrcode_path)
      DingtalkHelper.new(@app_info, options, qrcode_path, download_url).send_msg
    end

    def feishu_notifier(download_url, qrcode_path)
      FeishuHelper.new(@app_info, options, qrcode_path, download_url).send_msg
    end

    def wxwork_notifier(download_url)
      return if options[:wxwork_webhook].blank? && options[:wxwork_access_token].blank?

      webhook_url = options[:wxwork_webhook]
      webhook_url ||= "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=#{options[:wxwork_access_token]}"

      title = "#{@app_info[:name]}-#{@app_info[:version]}(Build #{@app_info[:build]}) #{@app_info[:type]}"
      payload = {
        "msgtype": 'news',
        "news": {
          "articles": [{
            "title": "#{title} uploaded",
            "description": "#{title} uploaded at #{Time.now}\nurl: #{download_url}\n#{options[:wxwork_custom_message]}\n",
            "url": download_url,
            "picurl": options[:wxwork_pic_url]
          }]
        }
      }
      DefaultRest.post(webhook_url, payload)
    end
  end
end