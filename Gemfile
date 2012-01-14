source 'http://rubygems.org'

gemspec

group :debug do
  gem 'ruby-debug',           :platforms => :mri_18

  # This is a dependency of ruby-debug. We're specifying it here because its
  # v0.45 is incompatible with Ruby v1.8.7.
  gem 'linecache', '<= 0.43', :platforms => :mri_18

  gem 'ruby-debug19',         :platforms => :mri_19
end

group :development do
  gem 'guard-rspec'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
end

group :doc do
  gem 'yard',                 :platforms => [:ruby, :mswin, :mingw]
  gem 'rdiscount',            :platforms => [:ruby, :mswin, :mingw]
end
