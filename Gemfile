source 'http://rubygems.org'

gemspec

group :debug do
  gem   'ruby-debug',             :require => false, :platforms => [:mri_18, :jruby]
  gem   'debugger',               :require => false, :platforms => [:mri_19, :mri_20]
end

group :doc do
  gem   'yard',           '~> 0', :require => false, :platforms => [:ruby, :mswin, :mingw]
  gem   'rdiscount',              :require => false, :platforms => [:ruby, :mswin, :mingw]

  gem   'relish',         '~> 0', :require => false, :platforms => :mri_19
end

group :tooling do
  gem   'appraisal',      '~> 0', :require => false
  gem   'guard-cucumber', '~> 1', :require => false, :platforms => :mri_19
  gem   'guard-rspec',    '~> 4', :require => false, :platforms => :mri_19
  if RUBY_PLATFORM =~ /darwin/i
    gem 'rb-fsevent',     '~> 0', :require => false
  end
end
