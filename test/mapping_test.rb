# encoding: utf-8

class MappingTest < Minitest::Test

  def test_mapping
    options = {
      token:   default_token,
      version: '1.1',
      build:   '1'
    }

    if ENV['TEST_MAPPING']
      assert FIR.mapping(default_dsym_mapping, options.merge(proj: default_bughd_project_ios_id))
      assert FIR.mapping(default_txt_mapping,  options.merge(proj: default_bughd_project_android_id))
    end
  end
end
