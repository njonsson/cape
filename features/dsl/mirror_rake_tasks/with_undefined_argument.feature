Feature: The #mirror_rake_tasks DSL method with an undefined argument

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: do not mirror any Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :this_does_not_exist
      end
      """
    When I run `cap -vT`
    Then the output should not contain "cap this_does_not_exist"
    And the output should not contain "cap with_period"
