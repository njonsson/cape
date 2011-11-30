Feature: The #mirror_rake_tasks DSL method with an argument of a defined namespace

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the Rake tasks in the matching namespace
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks 'my_namespace'
      end
      """
    When I run `cap -T`
    Then the output should not contain "cap with_period"
    And the output should contain:
      """
      cap my_namespace:in_a_namespace                            # My task in a namespace.
      """
    And the output should contain:
      """
      cap my_namespace:my_nested_namespace:in_a_nested_namespace # My task in a nested namespace.
      """

  Scenario: do not mirror Rake task 'with_period'
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :my_namespace
      end
      """
    When I run `cap -e with_period`
    Then the output should contain exactly:
      """
      The task `with_period' does not exist.

      """

  Scenario: mirror Rake task 'my_namespace:in_a_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :my_namespace
      end
      """
    When I run `cap -e my_namespace:in_a_namespace`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap my_namespace:in_a_namespace
      ------------------------------------------------------------
      My task in a namespace.


      """

  Scenario: mirror Rake task 'my_namespace:my_nested_namespace:in_a_nested_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :my_namespace
      end
      """
    When I run `cap -e my_namespace:my_nested_namespace:in_a_nested_namespace`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap my_namespace:my_nested_namespace:in_a_nested_namespace
      ------------------------------------------------------------
      My task in a nested namespace.


      """
