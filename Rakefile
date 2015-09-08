require 'bundler/gem_tasks'
require File.expand_path('../test/test_helper', __FILE__)

desc 'Run the tests.'
task :test do
  $LOAD_PATH << 'lib' << 'test'
  Dir['test/*_test.rb'].each { |f| require f[5..-4] }
end

task default: :test
