begin
  require 'appraisal'
rescue LoadError
end
begin
  require 'bundler/gem_tasks'
rescue LoadError
end

begin
  require 'yard'
rescue LoadError
else
  namespace :build do
    YARD::Rake::YardocTask.new :doc
  end
end

def define_features_task(name, options)
  begin
    require 'cucumber/rake/task'
  rescue LoadError
  else
    Cucumber::Rake::Task.new name, options[:desc] do |t|
      t.bundler = false

      cucumber_opts = [t.cucumber_opts]
      cucumber_opts << "--backtrace" if options[:backtrace]
      if options.key?(:format)
        cucumber_opts << "--format #{options[:format]}"
      else
        cucumber_opts << '--format pretty'
      end
      cucumber_opts << "--tags #{options[:tags]}" if options.key?(:tags)
      t.cucumber_opts = cucumber_opts.join(' ')
    end
  end
end

tags = `grep -Ehr "^\\s*@\\S+\\s*$" features`.split("\n").
                                              collect(&:strip).
                                              uniq.
                                              sort
options = {:desc => 'Test features'}
options[:tags] = '@focus' if tags.delete('@focus')
define_features_task :features, options

unless tags.empty?
  namespace :features do
    tags.each do |t|
      define_features_task t.gsub(/^@/, ''),
                           :desc => "Test features tagged #{t}", :tags => t
    end
  end
end

def define_spec_task(name, options={})
  desc options[:desc]
  begin
    require 'rspec/core/rake_task'
  rescue LoadError
  else
    RSpec::Core::RakeTask.new name do |t|
      t.rspec_opts ||= []
      t.rspec_opts << "--backtrace" if options[:backtrace]
      unless options[:debug] == false
        available = %w(debugger ruby-debug).detect do |debugger_library|
          begin
            require debugger_library
          rescue LoadError
            false
          else
            true
          end
        end
        if available
          t.rspec_opts << '--debug'
        else
          require 'cape/xterm'
          $stderr.puts Cape::XTerm.bold('*** Debugging tools not installed')
        end
      end
      t.rspec_opts << "--format #{options[:format]}" if options.key?(:format)
      t.pattern = options[:pattern] || %w(spec/*_spec.rb spec/**/*_spec.rb)
    end
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
  define_spec_task :spec, :desc => '', :backtrace => true,
                                       :debug => false,
                                       :format => :progress

  define_features_task :features, :desc => '', :backtrace => true,
                                               :format => :progress
end
task :test => %w(test:spec test:features)
