# encoding: utf-8

class PublishTest < Minitest::Test

  def test_publish
    options = {
      token: default_token,
      changelog: "test from fir-cli #{Time.now.to_i}"
    }

    assert FIR.publish(default_ipa, options)
    assert FIR.publish(default_apk, options)
  end
end
