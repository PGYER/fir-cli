require "bundler/gem_tasks"

desc "Run the tests."
task :test do
  $: << "lib" << "test"
  Dir["test/*_test.rb"].each { |f| require f[5..-1] }
end

task :default => :test

