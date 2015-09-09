# encoding: utf-8

class MeTest < Minitest::Test

  def test_me
    user_info = FIR.fetch_user_info(default_token)

    FIR.write_config(email: user_info.fetch(:email, ''), token: default_token)
    FIR.reload_config

    me_info = FIR.fetch_user_info(FIR.current_token)

    assert_equal default_email, me_info.fetch(:email, '')

    assert FIR.me
  end
end
