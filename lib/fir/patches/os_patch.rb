# encoding: utf-8

module OS
  class << self

    def windows?
      !(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
    end

    def mac?
      !(/darwin/ =~ RUBY_PLATFORM).nil?
    end

    def unix?
      !OS.windows?
    end

    def linux?
      OS.unix? && !OS.mac?
    end

    def set_locale
      system 'export LC_ALL=en_US.UTF-8'
      system 'export LC_CTYPE=en_US.UTF-8'
      system 'export LANG=en_US.UTF-8'
    end
  end
end
