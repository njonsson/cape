Feature: The #mirror_rake_tasks DSL method with valid options and environment variables

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  @deprecated
  Scenario: mirror the matching Rake task with its implementation (deprecated)
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'
      set :rails_env,    'rails-env'

      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
      *** DEPRECATED: `mirror_rake_tasks(:roles => :app) { |env| env["RAILS_ENV"] = "rails-env" }`. Use this instead: `mirror_rake_tasks { |recipes| recipes.options[:roles] = :app; recipes.env["RAILS_ENV"] = "rails-env" }`
        * executing `with_period'
        * executing "cd /current/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period RAILS_ENV=\"rails-env\""
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """

  Scenario: mirror the matching Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'
      set :rails_env,    'rails-env'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.options[:roles] = :app
          recipes.env['RAILS_ENV'] = lambda { rails_env }
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /current/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period RAILS_ENV=\"rails-env\""
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """
    And the output should not contain "DEPRECATED"
