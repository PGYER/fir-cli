# encoding: utf-8

require 'minitest/autorun'
require 'fir'

FIR.logger = Logger.new(STDOUT)

class Minitest::Test

  def default_token
    # '2dd8a99ef9d19c540bb583624b939960'
    '2dd8a99ef9d19c540bb583624b93996'
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
