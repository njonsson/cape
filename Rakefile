begin
  require 'bundler/gem_tasks'
rescue LoadError
end
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

Cucumber::Rake::Task.new :features, 'Test features' do |t|
  t.bundler = false
end

def define_spec_task(name, options={})
  RSpec::Core::RakeTask.new name do |t|
    t.rspec_opts ||= []
    unless options[:debug] == false
      begin
        require 'ruby-debug'
      rescue LoadError
      else
        t.rspec_opts << '--debug'
      end
    end
    t.pattern = %w(spec/*_spec.rb spec/**/*_spec.rb)
  end
end

desc 'Run specs'
define_spec_task :spec

desc 'Run specs and test features'
task ''       => [:spec, :features]
task :default => [:spec, :features]

# Support the 'gem test' command.
namespace :test do
  desc ''
  define_spec_task :specs, :debug => false

  Cucumber::Rake::Task.new :features, '' do |t|
    t.bundler = false
    t.cucumber_opts = '--backtrace'
  end
end
task :test => %w(test:specs test:features)
