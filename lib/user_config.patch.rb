require 'user_config'
class UserConfig
  class YAMLFile
    def [](key)
      return @cache[key] if defined? @cache[key]
      @cache[key] || @default[key]
    end
  end
end

