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
  CONFIG_PATH   = "#{ENV['HOME']}/.fir-cli"
  API_YML_PATH  = "#{File.dirname(__FILE__)}/fir/api.yml"
  APP_FILE_TYPE = %w(.ipa .apk).freeze

  include Util

  class << self
    attr_accessor :logger, :api, :config

    def api
      @api ||= YAML.load_file(API_YML_PATH).symbolize_keys
    end

    def config
      @config ||= YAML.load_file(CONFIG_PATH).symbolize_keys if File.exist?(CONFIG_PATH)
    end

    def reload_config
      @config = YAML.load_file(CONFIG_PATH).symbolize_keys
    end

    def write_config hash
      File.open(CONFIG_PATH, 'w+') { |f| f << YAML.dump(hash) }
    end

    def current_token
      @token ||= config[:token] if config
    end

    def get url, params = {}
      begin
        res = RestClient.get(url, default_headers.merge(params: params))
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    def post url, query
      begin
        res = RestClient.post(url, query, default_headers)
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    def patch url, query
      begin
        res = RestClient.patch(url, query, default_headers)
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    def put url, query
      begin
        res = RestClient.put(url, query, default_headers)
      rescue => e
        logger.error "#{e.class}\n#{e.message}"
        exit 1
      end

      JSON.parse(res.body.force_encoding("UTF-8"), symbolize_names: true)
    end

    def default_headers
      { content_type: :json, source: 'fir-cli', cli_version: FIR::VERSION }
    end

    alias_method :☠, :exit
  end
end
