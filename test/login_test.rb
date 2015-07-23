# encoding: utf-8

class LoginTest < Minitest::Test

  def test_login
    user_info = FIR.fetch_user_info(default_token)

    assert_equal default_email, user_info.fetch(:email, '')

    assert FIR.login(default_token)
  end
end
