# coding: utf-8
module Fir
  class Cli
    no_commands do
      # %w(token email verbose origin branch mobile_provision sign entitlements private_key).each do |_m|
      %w(token email verbose origin branch mobile_provision entitlements private_key).each do |_m|
        define_method "_opt_#{_m}" do
          unless instance_variable_get("@#{_m}")
            instance_variable_set("@#{_m}", options[_m.to_sym] || @config[_m] )
          end
          instance_variable_get("@#{_m}")
        end
        private "_opt_#{_m}".to_sym
      end
      # %w(publish resign quiet color trim).each do |_m|
      %w(publish quiet color trim).each do |_m|
        define_method "_opt_#{_m}" do
          return false if options[_m.to_sym] == false
          unless instance_variable_get("@#{_m}")
            instance_variable_set("@#{_m}", options[_m.to_sym] || @config[_m] )
          end
          instance_variable_get("@#{_m}")
        end
        private "_opt_#{_m}".to_sym
      end
    end
    private
    def _opt (*opts)
      opts.map { |_opt| method("_opt_#{_opt}").call }
    end
    def _opt? (*opts)
      opts.each { |_opt| return false if !method("_opt_#{_opt}").call }
    end
  end
end
