Feature: The #mirror_rake_tasks DSL method with a defined namespace

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the Rake tasks in the matching namespace
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :my_namespace
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap my_namespace                                           # A task that shadows a names...
      """
    And the output should contain:
      """
      cap my_namespace:in_a_namespace                            # My task in a namespace.
      """
    And the output should contain:
      """
      cap my_namespace:my_nested_namespace:in_a_nested_namespace # My task in a nested namespace.
      """
    And the output should not contain "period"

  Scenario: mirror a Rake task that shadows the matching namespace with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks 'my_namespace'
      end
      """
      When I run `cap my_namespace`
    Then the output should contain:
      """
        * executing `my_namespace'
        * executing "cd /current/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake my_namespace"
      `my_namespace' is only run for servers matching {}, but no servers matched
      """

  Scenario: mirror a Rake task in the matching namespace with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks :my_namespace
      end
      """
      When I run `cap my_namespace:my_nested_namespace:in_a_nested_namespace`
    Then the output should contain:
      """
        * executing `my_namespace:my_nested_namespace:in_a_nested_namespace'
        * executing "cd /current/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake my_namespace:my_nested_namespace:in_a_nested_namespace"
      `my_namespace:my_nested_namespace:in_a_nested_namespace' is only run for servers matching {}, but no servers matched
      """
