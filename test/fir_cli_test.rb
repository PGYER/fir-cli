# encoding: utf-8

require 'minitest/autorun'
require 'fir'

class Minitest::Test

  def default_token
    '2dd8a99ef9d19c540bb583624b939960'
  end

  def default_email
    'fir-cli_test@fir.im'
  end

  def default_apk
    File.expand_path('../cases', __FILE__) + '/test_apk.apk'
  end

  def default_ipa
    File.expand_path('../cases', __FILE__) + '/test_ipa.ipa'
  end

  def default_device_udid
    "cf8b87e3f469d7b185fd64c057778aecbc2017a6"
  end

  def default_distribution_name
    'iOSTeam Provisioning Profile: im.fir.* - Fly It Remotely LLC.'
  end
end

class LoginTest < Minitest::Test

  def test_login
    user_info = FIR.fetch_user_info(default_token)

    assert_equal default_email, user_info.fetch(:email, '')
  end
end

class MeTest < Minitest::Test

  def test_me
    user_info = FIR.fetch_user_info(default_token)

    FIR.write_config(email: user_info.fetch(:email, ''), token: default_token)
    FIR.reload_config

    me_info = FIR.fetch_user_info(FIR.current_token)

    assert_equal default_email, me_info.fetch(:email, '')
  end
end

class InfoTest < Minitest::Test

  def test_apk_info
    info = FIR.apk_info(default_apk, true)

    assert_equal 'android',         info[:type]
    assert_equal 'im.fir.sdk.test', info[:identifier]
    assert_equal 'TestCrash',       info[:name]
    assert_equal '3',               info[:build]
    assert_equal '3.0',             info[:version]

    assert_equal true, File.exist?(info[:icons].first)
  end

  def test_ipa_info
    info = FIR.ipa_info(default_ipa, true)

    assert_equal 'ios',                     info[:type]
    assert_equal 'im.fir.build-ipa',        info[:identifier]
    assert_equal 'build_ipa',               info[:name]
    assert_equal '1',                       info[:build]
    assert_equal '1.0',                     info[:version]

    # Only for OSX
    # assert_equal nil,                       info[:display_name]
    # assert_equal default_device_udid,       info[:devices].first
    # assert_equal 'adhoc',                   info[:release_type]
    # assert_equal default_distribution_name, info[:distribution_name]

    assert_equal true, info[:plist].is_a?(Hash)
    assert_equal true, info[:mobileprovision].is_a?(Hash)
  end
end
