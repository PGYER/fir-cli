# encoding: utf-8

module RestClient
  class Request
    def default_headers
      { content_type: :json, source: 'fir-cli', version: FIR::VERSION }
    end
  end
end
