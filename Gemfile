# coding: utf-8
if ENV['USE_CHINA_GEM_SOURCE']
  source 'http://gems.ruby-china.com'
else
  source 'https://rubygems.org'
end

# Specify your gem's dependencies in fir.gemspec
gemspec
gem 'codeclimate-test-reporter', group: :test, require: nil

# Fix compatibility with Ruby 3.2.2
# mime-types 3.2.2 uses _1, _2, _3 as parameter names which are reserved in Ruby 2.7+
gem 'mime-types', '>= 3.3.0'
