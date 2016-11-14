# encoding: utf-8

class BuildAppTest < Minitest::Test

  def test_build_app
    if ENV['BUILD_TEST']
      options = OpenStruct.new
      options.send('publish?=', true)

      assert FIR.build_ipa(default_ipa_project, options)
      assert FIR.build_apk(default_apk_project, options)

      assert FIR.build_ipa(default_ipa_git_url, options)
      assert FIR.build_apk(default_apk_git_url, options)
    end
  end
end
