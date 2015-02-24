# encoding: utf-8

require 'thor'
require 'logger'
require 'yaml'
require 'rest-client'
require 'json'
require 'lagunitas'
require 'securerandom'
require 'fileutils'
require 'pry'

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
  API_YML_PATH  = "./lib/fir/api.yml"
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
        res = RestClient.get(url, params: params)
      rescue RestClient::Exception => e
        logger.error e.response
        exit 1
      end
      JSON.parse(res.body, symbolize_names: true)
    end

    def post url, query, content_type = :json
      begin
        res = RestClient.post(url, query, { content_type: content_type })
      rescue RestClient::Exception => e
        logger.error e.response
        exit 1
      end
      JSON.parse(res.body, symbolize_names: true)
    end

    def put url, query, content_type = :json
      begin
        res = RestClient.put(url, query, { content_type: content_type })
      rescue RestClient::Exception => e
        logger.error e.response
        exit 1
      end
      JSON.parse(res.body, symbolize_names: true)
    end

    alias_method :☠, :exit
  end
end
