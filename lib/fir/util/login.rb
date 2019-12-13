# frozen_string_literal: true
# require 'byebug'

module FIR
  module Login
    def login(token)
      check_token_cannot_be_blank token

      user_info = fetch_user_info(token)

      unless config.blank?
        logger.info "Login succeed, previous user's email: #{config[:email]}"
      end
      write_config(email: user_info.fetch(:email, ''), token: token)
      reload_config
      logger.info "Login succeed, current  user's email: #{config[:email]}"
      
      AdmqrKnife.visit(
        unique_code: 'fir_cli_login',
        tag: 'fir_cli',
        referer: "https://#{FIR::VERSION}.fir-cli/#{config[:email]}"
      )
      logger_info_blank_line
    end
  end
end
