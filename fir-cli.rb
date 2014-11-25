require 'thor'
module Fir
  class Cli < Thor
  end
end

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|f| require f }
Dir[File.dirname(__FILE__) + '/lib/fir-cli-commands/*.rb'].each {|f| require f }
