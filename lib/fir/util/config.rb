# encoding: utf-8

module FIR
  module Config
    CONFIG_PATH   = "#{ENV['HOME']}/.fir-cli"
    APP_INFO_PATH = "#{ENV['HOME']}/.fir-cli-app"
    API_YML_PATH  = ENV['API_YML_PATH'] || File.expand_path('../../', __FILE__) + '/api.yml'
    XCODE_WRAPPER_PATH  = File.expand_path('../../', __FILE__) + '/xcode_wrapper.sh'
    APP_FILE_TYPE = %w(.ipa .apk).freeze

    def fir_api
      @fir_api ||= YAML.load_file(API_YML_PATH).deep_symbolize_keys[:fir]
    end

    def bughd_api
      @bughd_api ||= YAML.load_file(API_YML_PATH).deep_symbolize_keys[:bughd]
    end

    def config
      return unless File.exist?(CONFIG_PATH)
      @config ||= YAML.load_file(CONFIG_PATH).deep_symbolize_keys
    end

    def reload_config
      @config = YAML.load_file(CONFIG_PATH).deep_symbolize_keys
    end

    def write_config(hash)
      File.open(CONFIG_PATH, 'w+') { |f| f << YAML.dump(hash) }
    end

    def write_app_info(hash)
      File.open(APP_INFO_PATH, 'w+') { |f| f << YAML.dump(hash) }
    end

    def current_token
      return @token = ENV["API_TOKEN"] if ENV["API_TOKEN"]
      @token ||= config[:token] if config
    end

    alias_method :☠, :exit
  end
end
