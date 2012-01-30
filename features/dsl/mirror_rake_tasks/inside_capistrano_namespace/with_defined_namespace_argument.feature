Feature: The #mirror_rake_tasks DSL method, inside a Capistrano namespace, with an argument of a defined namespace

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the Rake tasks in the matching namespace
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks 'my_namespace'
        end
      end
      """
    When I run `cap -T`
    Then the output should not contain "cap ns:with_period"
    And the output should contain:
      """
      cap ns:my_namespace                                           # A task that shadows a names...
      """
    And the output should contain:
      """
      cap ns:my_namespace:in_a_namespace                            # My task in a namespace.
      """
    And the output should contain:
      """
      cap ns:my_namespace:my_nested_namespace:in_a_nested_namespace # My task in a nested namespace.
      """

  Scenario: do not mirror Rake task 'with_period'
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks :my_namespace
        end
      end
      """
    When I run `cap -e ns:with_period`
    Then the output should contain exactly:
      """
      The task `ns:with_period' does not exist.

      """

  Scenario: mirror Rake task 'my_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks :my_namespace
        end
      end
      """
    When I run `cap -e ns:my_namespace`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:my_namespace
      ------------------------------------------------------------
      A task that shadows a namespace.


      """

  Scenario: mirror Rake task 'my_namespace:in_a_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks :my_namespace
        end
      end
      """
    When I run `cap -e ns:my_namespace:in_a_namespace`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:my_namespace:in_a_namespace
      ------------------------------------------------------------
      My task in a namespace.


      """

  Scenario: mirror Rake task 'my_namespace:my_nested_namespace:in_a_nested_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks :my_namespace
        end
      end
      """
    When I run `cap -e ns:my_namespace:my_nested_namespace:in_a_nested_namespace`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:my_namespace:my_nested_namespace:in_a_nested_namespace
      ------------------------------------------------------------
      My task in a nested namespace.


      """
