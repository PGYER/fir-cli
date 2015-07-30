# encoding: utf-8

module FIR
  module Mapping

    def upload_mapping_file *args, options
      user_info = fetch_user_info(options[:token] || current_token)

      uuid = user_info[:uuid]

    end
  end
end
