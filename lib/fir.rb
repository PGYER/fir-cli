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
  include Util
end
