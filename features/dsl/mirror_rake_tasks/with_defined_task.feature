Feature: The #mirror_rake_tasks DSL method with a defined task

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :with_period
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap with_period # Ends with period.
      """
    And the output should not contain "without_period"
    And the output should not contain "my_namespace"

  Scenario: mirror the matching Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks 'with_period'
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
