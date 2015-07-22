# encoding: utf-8

module FIR
  module Me

    def me
      check_logined

      if user_info = fetch_user_info(current_token)
        email = user_info.fetch(:email, '')
        name  = user_info.fetch(:name, '')

        logger.info "Login succeed, current  user's email: #{email}"
        logger.info "Login succeed, current  user's name: #{name}"
      end
    end
  end
end
