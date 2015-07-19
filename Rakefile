require "bundler/gem_tasks"

desc "Run the tests."
task :test do
  $: << "lib" << "test"
  Dir["test/*_test.rb"].each { |f| require f[5..-1] }
end

task :default => :test

# Run the rdoc task to generate rdocs for this gem
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  require "fir/version"
  version = FIR::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fir-cli #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
