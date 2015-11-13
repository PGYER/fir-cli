# encoding: utf-8

require 'thor'
require 'logger'
require 'yaml'
require 'rest-client'
require 'json'
require 'securerandom'
require 'fileutils'
require 'cfpropertylist'
require 'tempfile'
require 'rqrcode'

# TODO: remove rescue when https://github.com/tajchert/ruby_apk/pull/4 merged
begin
  require 'ruby_android'
rescue LoadError
  require 'ruby_apk'
end

require 'fir/patches'
require 'fir/util'
require 'fir/version'
require 'fir/cli'

module FIR
  ROOT_PATH     = File.expand_path('../', __FILE__)
  CONFIG_PATH   = "#{ENV['HOME']}/.fir-cli"
  API_YML_PATH  = ROOT_PATH + '/fir/api.yml'
  APP_FILE_TYPE = %w(.ipa .apk).freeze

  include Util
end
