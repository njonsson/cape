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

def define_features_task(name, options)
  Cucumber::Rake::Task.new name, options[:desc] do |t|
    t.bundler = false
    t.cucumber_opts = options[:cucumber_opts] if options.key?(:cucumber_opts)
  end
end

define_features_task :features, :desc => 'Test features'

tags = `grep -Ehr "^\\s*@\\S+\\s*$" features`.split("\n").
                                              collect(&:strip).
                                              uniq.
                                              sort
unless tags.empty?
  namespace :features do
    tags.each do |t|
      define_features_task t.gsub(/^@/, ''),
                           :desc => "Test features tagged #{t}",
                           :cucumber_opts => "-t #{t}"
    end
  end
end

def define_spec_task(name, options={})
  desc options[:desc]
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
    t.pattern = options[:pattern] || %w(spec/*_spec.rb spec/**/*_spec.rb)
  end
end

define_spec_task :spec, :desc => 'Run specs'

namespace :spec do
  uncommitted_specs = `git ls-files --modified --others *_spec.rb`.split("\n")
  desc = 'Run uncommitted specs'
  desc += ' (none)' if uncommitted_specs.empty?
  define_spec_task :uncommitted, :desc => desc, :pattern => uncommitted_specs
end

desc 'Run specs and test features'
task ''       => [:spec, :features]
task :default => [:spec, :features]

# Support the 'gem test' command.
namespace :test do
  define_spec_task :spec, :desc => '', :debug => false

  Cucumber::Rake::Task.new :features, '' do |t|
    t.bundler = false
    t.cucumber_opts = '--backtrace'
  end
end
task :test => %w(test:spec test:features)
