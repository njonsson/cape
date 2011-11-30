require 'bundler/gem_tasks'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

begin
  require 'yard'
rescue LoadError
else
  namespace :build do
    YARD::Rake::YardocTask.new :doc
  end
end

Cucumber::Rake::Task.new :features, 'Test features'

def define_spec_task(name, options={})
  RSpec::Core::RakeTask.new name do |t|
    t.rspec_opts = ['--color']
    unless options[:debug] == false
      begin
        require 'ruby-debug'
      rescue LoadError
      else
        t.rspec_opts << '--debug'
      end
    end
    t.pattern = "spec/**/*_spec.rb"
  end
end

desc 'Run all specs'
define_spec_task :spec

desc 'Run all specs and test features'
task ''       => [:spec, :features]
task :default => [:spec, :features]

# Support the 'gem test' command.
desc ''
define_spec_task :test, :debug => false
