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
    passwd    = SecureRandom.hex[0..9]
    is_opened = false

    update_info = { short: short, password: passwd, open: is_opened }
    FIR.publish(default_ipa, @options.merge(update_info))

    FIR.instance_eval do
      FIR.instance_variable_set(:@test_info, FIR.fetch_app_info)
    end

    info = FIR.instance_variable_get(:@test_info)

    assert_equal short, info[:short]
    assert_equal passwd, info[:passwd]
    assert_equal is_opened, info[:is_opened]
  end
end
