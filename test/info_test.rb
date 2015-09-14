# encoding: utf-8

class InfoTest < Minitest::Test

  def test_apk_info
    info = FIR.apk_info(default_apk, full_info: true)

    assert_equal 'android',                 info[:type]
    assert_equal 'com.bughd.myapplication', info[:identifier]
    assert_equal 'My Application',          info[:name]
    assert_equal '1',                       info[:build]
    assert_equal '1.0',                     info[:version]

    assert_equal true, File.exist?(info[:icons].first)

    assert FIR.info(default_apk, {})
  end

  def test_ipa_info
    info = FIR.ipa_info(default_ipa, full_info: true)

    assert_equal 'ios',              info[:type]
    assert_equal 'im.fir.build-ipa', info[:identifier]
    assert_equal 'build_ipa',        info[:name]
    assert_equal '1',                info[:build]
    assert_equal '1.0',              info[:version]

    # Only for OSX
    # assert_equal nil,                       info[:display_name]
    # assert_equal default_device_udid,       info[:devices].first
    # assert_equal 'adhoc',                   info[:release_type]
    # assert_equal default_distribution_name, info[:distribution_name]

    assert FIR.info(default_ipa, {})
  end
end
