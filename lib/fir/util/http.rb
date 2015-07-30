# encoding: utf-8

module FIR
  module Http

    def get url, params = {}, timeout = 300
      begin
        res = ::RestClient::Request.execute(
          method:  :get,
          url:     url,
          timeout: timeout,
          headers: default_headers.merge(params: params)
        )
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    def post url, query, timeout = 300
      begin
        res = ::RestClient::Request.execute(
          method:  :post,
          url:     url,
          payload: query,
          timeout: timeout,
          headers: default_headers
        )
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    def patch url, query, timeout = 300
      begin
        res = ::RestClient::Request.execute(
          method:  :patch,
          url:     url,
          payload: query,
          timeout: timeout,
          headers: default_headers
        )
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    def put url, query, timeout = 300
      begin
        res = ::RestClient::Request.execute(
          method:  :put,
          url:     url,
          payload: query,
          timeout: timeout,
          headers: default_headers
        )
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    private

      def default_headers
        { content_type: :json, source: 'fir-cli', cli_version: FIR::VERSION }
      end
  end
end
