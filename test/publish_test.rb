# encoding: utf-8

class PublishTest < Minitest::Test

  def setup
    @options = {
      token:     default_token,
      changelog: "test from fir-cli #{Time.now.to_i}"
    }
  end

  def test_simple_publish
    assert FIR.publish(default_ipa, @options)
    assert FIR.publish(default_apk, @options)
  end

  def test_update_app_info
    short     = SecureRandom.hex[3..9]
    is_opened = (rand(100) % 2) == 0

    update_info = { short: short, open: is_opened }
    FIR.publish(default_ipa, @options.merge(update_info))

    info = FIR.fetch_app_info

    assert_equal short, info[:short]
    assert_equal is_opened, info[:is_opened]
  end

  def test_update_app_passwd
    short     = SecureRandom.hex[3..9]
    is_opened = (rand(100) % 2) == 0
    passwd    = SecureRandom.hex[0..9]

    update_info = { short: short, password: passwd, open: is_opened }
    FIR.publish(default_ipa, @options.merge(update_info))

    info = FIR.fetch_app_info

    assert_equal short, info[:short]
    assert_equal passwd, info[:passwd]
    assert_equal false, info[:is_opened]
  end
end
