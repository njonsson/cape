# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'cape/version'

Gem::Specification.new do |s|
  s.name        = 'cape'
  s.version     = Cape::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nils Jonsson']
  s.email       = %w(cape@nilsjonsson.com)
  s.homepage    = ''
  s.summary     = 'Dynamically generates Capistrano recipes for Rake tasks'
  s.description = 'Cape provides a simple DSL for selecting Rake tasks to be ' +
                  'made available as documented Capistrano recipes. You can '  +
                  'pass required arguments to Rake tasks via environment '     +
                  'variables.'
  s.license     = 'MIT'

  # TODO: Apply for RubyForge project
  # s.rubyforge_project = 'cape'

  s.required_ruby_version = '>= 1.8.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
                      File.basename f
                    end
  s.require_paths = %w(lib)
  s.has_rdoc      = true

  s.add_development_dependency 'aruba'
  s.add_development_dependency 'capistrano'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec',      '~> 2.7'
end
