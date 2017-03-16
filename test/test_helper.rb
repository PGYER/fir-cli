# encoding: utf-8

# CodeClimate::TestReporter.start
require 'codeclimate-test-reporter'
require 'simplecov'
SimpleCov.start


require 'minitest/autorun'
require 'ostruct'
require 'securerandom'
require 'fir'

FIR.logger = Logger.new(STDOUT)

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

  def default_ipa_project
    File.expand_path('../projects', __FILE__) + '/ipa'
  end

  def default_apk_project
    File.expand_path('../projects', __FILE__) + '/apk'
  end

  def default_ipa_git_url
    'git@github.com:NaixSpirit/build_ipa_example.git'
  end

  def default_apk_git_url
    'git@github.com:NaixSpirit/build_apk_example.git'
  end

  def default_bughd_project_ios_id
    '55bb2839692d647a46000004'
  end

  def default_bughd_project_android_id
    '55be454a692d351278000002'
  end

  def default_dsym_mapping
    File.expand_path('../cases', __FILE__) + '/test_ipa_dsym'
  end

  def default_txt_mapping
    File.expand_path('../cases', __FILE__) + '/test_apk_txt'
  end

  def bigger_txt_mapping
    File.expand_path('../projects', __FILE__) + '/biggggger.txt'
  end

  def default_device_udid
    'cf8b87e3f469d7b185fd64c057778aecbc2017a6'
  end

  def default_distribution_name
    'iOSTeam Provisioning Profile: im.fir.* - Fly It Remotely LLC.'
  end

end


# 跑完测试之后再发结果到Codelimate
# 测试CODECLIMATE_REPO_TOKEN: c454b9a54151b3ed3e18949279aec49d6a25bf507706815f99a919f1c01679ed
Minitest.after_run do  
  COVERAGE_FILE = "coverage/.resultset.json".freeze
  if (repo_token = ENV["CODECLIMATE_REPO_TOKEN"]) && !repo_token.empty?
    if File.exist?(COVERAGE_FILE)
      begin
        results = JSON.parse(File.read(COVERAGE_FILE))
      rescue JSON::ParserError => e
        $stderr.puts "Error encountered while parsing #{COVERAGE_FILE}: #{e}"
      end

      CodeClimate::TestReporter.run(results)
    else
      $stderr.puts "Coverage results not found"
    end
  end
end
