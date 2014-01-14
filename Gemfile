source 'http://rubygems.org'

gemspec

group :debug do
  gem   'ruby-debug',             :platforms => [:mri_18, :jruby]
  gem   'debugger',               :platforms => [:mri_19, :mri_20]
end

group :doc do
  gem   'yard',           '~> 0', :platforms => [:ruby, :mswin, :mingw]
  gem   'rdiscount',              :platforms => [:ruby, :mswin, :mingw]

  gem   'relish',         '~> 0', :platforms => :mri_19
end

group :tooling do
  gem   'appraisal',      '~> 0'
  gem   'guard-cucumber', '~> 1', :platforms => :mri_19
  gem   'guard-rspec',    '~> 4', :platforms => :mri_19
  if RUBY_PLATFORM =~ /darwin/i
    gem 'rb-fsevent',     '~> 0', :require => false
  end
end
