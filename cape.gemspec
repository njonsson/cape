# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'cape/version'

Gem::Specification.new do |s|
  s.name        = 'cape'
  s.version     = Cape::VERSION
  s.summary     = 'Dynamically generates Capistrano recipes for Rake tasks'
  s.description = <<-end_description.gsub(/^\s+/, '').chomp
                  Cape dynamically generates Capistrano recipes for Rake tasks.
                  It provides a DSL for reflecting on Rake tasks and mirroring
                  them as documented Capistrano recipes. You can pass Rake task
                  arguments via environment variables.
                  end_description
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nils Jonsson']
  s.email       = %w(cape@nilsjonsson.com)
  s.homepage    = 'http://njonsson.github.io/cape'
  s.license     = 'MIT'

  s.rubyforge_project = 'cape'

  s.required_ruby_version = '>= 1.8.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
                      File.basename f
                    end
  s.require_paths = %w(lib)
  s.has_rdoc      = true

  s.add_development_dependency 'aruba',      '~> 0'
  s.add_development_dependency 'capistrano', '~> 2'
  s.add_development_dependency 'rake',       '>= 0.9.3'
  s.add_development_dependency 'rspec',      '~> 2'

  # Avoid Cucumber's warnings about JSON parser performance.
  s.add_development_dependency 'json_pure'
end
