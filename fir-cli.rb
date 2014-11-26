require 'uri'
require 'thor'
require 'json'
require 'pathname'
require 'tempfile'
require 'securerandom'

require 'thor'
require 'paint'
require 'pngdefry'
require 'user_config'
require 'rest_client'
require 'lagunitas'
require 'ruby_apk'
require 'highline/import'

module Fir
  class Cli < Thor
  end
end

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|f| require f }
Dir[File.dirname(__FILE__) + '/lib/fir-cli-commands/*.rb'].each {|f| require f }
