interactor :off

guard :rspec, :all_after_pass => true,
              :all_on_start   => false,
              :keep_failed    => false,
              :cmd => "bundle exec rspec --debug #{File.read('.rspec').chomp.gsub "\n", ' '}" do
  # Run the corresponding spec (or all specs) when code changes.
  watch(%r{^lib/(.+)\.rb$}) do |match|
    Dir["spec/#{match[1]}_spec.rb"].first || 'spec'
  end

  # Run a spec when it changes.
  watch %r{^spec/.+_spec\.rb$}

  # Run all specs when the RSpec configuration changes.
  watch('.rspec'             ) { 'spec' }
  watch('spec/spec_helper.rb') { 'spec' }

  # Run all specs when the bundle changes.
  watch('Gemfile.lock') { 'spec' }
end

guard :cucumber, :all_after_pass => true,
                 :all_on_start   => false,
                 :keep_failed    => false,
                 :focus_on => 'focus' do
  # Run run all features when code changes.
  watch(%r{^lib/(.+)\.rb$}) { 'features' }

  # Run the corresponding feature (or all features) when a step definition
  # changes.
  watch(%r{^features/step_definitions\.rb$}) { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |match|
    Dir["features/**/#{match[1]}.feature"].first || 'features'
  end

  # Run a feature when it changes.
  watch %r{^features/.+\.feature$}

  # Run all features when the Cucumber configuration changes.
  watch(%r{^features/support/.+$}) { 'features' }

  # Run all features when the bundle changes.
  watch('Gemfile.lock') { 'features' }
end
