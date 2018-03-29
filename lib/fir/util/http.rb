
# frozen_string_literal: true

require 'api_tools'

module FIR
  module Http
    include ApiTools::DefaultRestModule

    alias old_default_options default_options
    def default_options
      @default_options = old_default_options.merge(timeout: 300)
      if ENV['FIR_TIMEOUT']
        @default_options[:timeout] = ENV['FIR_TIMEOUT'].to_i
      end
      unless ENV['UPLOAD_VERIFY_SSL']
        @default_options.merge!(other_base_execute_option: {
                                  verify_ssl: OpenSSL::SSL::VERIFY_NONE
                                })
      end
    end
  end
end
