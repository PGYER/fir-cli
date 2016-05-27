# encoding: utf-8

module FIR
  module Http
    MAX_RETRIES = 5

    %w(get post patch put).each do |_m|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{_m}(url, params = {})
          query = :#{_m} == :get ? { params: params } : params
          begin
            res = ::RestClient.#{_m}(url, query)
          rescue => e
            @retries ||= 0
            logger.error(e.message.to_s)
            if @retries < MAX_RETRIES
              @retries += 1
              logger.info("Retry \#{@retries} times......")
              sleep 2
              retry
            else
              exit 1
            end
          end
          JSON.parse(res.body.force_encoding('UTF-8'), symbolize_names: true)
        end
      METHOD
    end
  end
end
