# encoding: utf-8

module FIR
  module Login
    def login(token)
      check_token_cannot_be_blank token

      user_info = fetch_user_info(token)

      logger.info "Login succeed, previous user's email: #{config[:email]}" unless config.blank?
      write_config(email: user_info.fetch(:email, ''), token: token)
      reload_config
      logger.info "Login succeed, current  user's email: #{config[:email]}"
      logger_info_blank_line
    end
  end
end
