# encoding: utf-8

module FIR
  module Config
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

    def current_token
      @token ||= config[:token] if config
    end

    alias_method :☠, :exit
  end
end
