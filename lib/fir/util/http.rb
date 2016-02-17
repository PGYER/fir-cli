# encoding: utf-8

module FIR
  module Http
    DEFAULT_TIMEOUT = 300

    def get(url, params = {})
      tries = 5
      begin
        res = ::RestClient::Request.execute(
          method:  :get,
          url:     url,
          timeout: DEFAULT_TIMEOUT,
          headers: default_headers.merge(params: params)
        )
      rescue => e
        logger.error e.message.to_s
        if tries > 0
          logger.info "Retry in #{tries} times......"
          tries -= 1
          retry
        else
          exit 1
        end
      end

      JSON.parse(res.body.force_encoding('UTF-8'), symbolize_names: true)
    end

    %w(post patch put).each do |method|
      define_method method do |url, query|
        tries = 5
        begin
          res = ::RestClient::Request.execute(
            method:  method.to_sym,
            url:     url,
            payload: query,
            timeout: DEFAULT_TIMEOUT,
            headers: default_headers
          )
        rescue => e
          logger.error e.message.to_s
          if tries > 0
            logger.info "Retry in #{tries} times......"
            tries -= 1
            retry
          else
            exit 1
          end
        end

        JSON.parse(res.body.force_encoding('UTF-8'), symbolize_names: true)
      end
    end

    private

    def default_headers
      { content_type: :json, source: 'fir-cli', version: FIR::VERSION }
    end
  end
end
