Feature: The #mirror_rake_tasks DSL method with environment variables

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror a Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'
      set :rails_env,    'production'

      Cape do
        mirror_rake_tasks do |env|
          env['RAILS_ENV']  = rails_env
          env[nil]          = 'foo'
          env['FOO']        = nil
          env['SOME_OTHER'] = 'var'
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period RAILS_ENV=\"production\" SOME_OTHER=\"var\""
      `with_period' is only run for servers matching {}, but no servers matched
      """