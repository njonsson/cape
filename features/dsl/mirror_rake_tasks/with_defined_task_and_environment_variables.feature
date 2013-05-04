Feature: The #mirror_rake_tasks DSL method with a defined task and environment variables

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  @deprecated
  Scenario: mirror only the matching Rake task (deprecated)
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :with_period do |env|
          env['RAILS_ENV'] = rails_env
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap with_period # Ends with period.
      """
    And the output should not contain "without_period"
    And the output should not contain "my_namespace"
    And the output should contain:
      """
      *** DEPRECATED: Referencing Capistrano variables from Cape without wrapping them in a block, a lambda, or another callable object
      """

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :with_period do |recipes|
          recipes.env['RAILS_ENV'] = lambda { rails_env }
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap with_period # Ends with period.
      """
    And the output should not contain "without_period"
    And the output should not contain "my_namespace"
    And the output should not contain "DEPRECATED"

  @deprecated
  Scenario: mirror the matching Rake task with its implementation (deprecated)
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'
      set :rails_env,    'rails-env'

      Cape do
        mirror_rake_tasks 'with_period' do |env|
          env['RAILS_ENV'] = rails_env
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
      *** DEPRECATED: `mirror_rake_tasks("with_period") { |env| env["RAILS_ENV"] = "rails-env" }`. Use this instead: `mirror_rake_tasks("with_period") { |recipes| recipes.env["RAILS_ENV"] = "rails-env" }`
        * executing `with_period'
      """
    And the output should contain:
      """
      `with_period' is only run for servers matching {}, but no servers matched
      """

  Scenario: mirror the matching Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'
      set :rails_env,    'rails-env'

      Cape do
        mirror_rake_tasks 'with_period' do |recipes|
          recipes.env['RAILS_ENV'] = lambda { rails_env }
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
      """
    And the output should contain:
      """
      `with_period' is only run for servers matching {}, but no servers matched
      """
    And the output should not contain "DEPRECATED"
