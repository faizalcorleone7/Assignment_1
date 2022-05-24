require 'rake'
require 'rspec/core/rake_task'

task :test do
  system "rspec", "test/test_connection_spec.rb"
end
