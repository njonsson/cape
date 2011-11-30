Feature: The #mirror_rake_tasks DSL method with an argument of a defined task

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks 'with_period'
      end
      """
    When I run `cap -T`
    Then the output should contain:
      """
      cap with_period # Ends with period.
      """
    And the output should not contain "cap without_period"

  Scenario: mirror Rake task 'with_period' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :with_period
      end
      """
    When I run `cap -e with_period`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap with_period
      ------------------------------------------------------------
      Ends with period.


      """

  Scenario: do not mirror Rake task 'without_period'
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :with_period
      end
      """
    When I run `cap -e without_period`
    Then the output should contain exactly:
      """
      The task `without_period' does not exist.

      """
