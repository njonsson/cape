Feature: The #mirror_rake_tasks DSL method, inside a Capistrano namespace, without arguments

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror all non-hidden Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -T`
    Then the output should contain:
      """
      cap ns:with_period                                            # Ends with period.
      """
    And the output should contain:
      """
      cap ns:without_period                                         # Ends without period.
      """
    And the output should contain:
      """
      cap ns:long                                                   # My long task -- it has a ve...
      """
    And the output should contain:
      """
      cap ns:with_one_arg                                           # My task with one argument.
      """
    And the output should contain:
      """
      cap ns:my_namespace:in_a_namespace                            # My task in a namespace.
      """
    And the output should contain:
      """
      cap ns:my_namespace:my_nested_namespace:in_a_nested_namespace # My task in a nested namespace.
      """
    And the output should contain:
      """
      cap ns:with_two_args                                          # My task with two arguments.
      """
    And the output should contain:
      """
      cap ns:with_three_args                                        # My task with three arguments.
      """
    And the output should not contain "cap hidden_task"

  Scenario: mirror Rake task 'with_period' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -e ns:with_period`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:with_period
      ------------------------------------------------------------
      Ends with period.


      """

  Scenario: mirror Rake task 'with_period' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'

      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap ns:with_period`
    Then the output should contain:
      """
        * executing `ns:with_period'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env rake with_period"
      """

  Scenario: mirror Rake task 'without_period' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -e ns:without_period`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:without_period
      ------------------------------------------------------------
      Ends without period.


      """

  Scenario: mirror Rake task 'long' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -e ns:long`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:long
      ------------------------------------------------------------
      My long task -- it has a very, very, very, very, very, very, very, very, very,
      very, very, very, very, very, very, very, very, very, very, very, very, very,
      very, very, very, very long description.


      """

  Scenario: mirror Rake task 'with_one_arg' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -e ns:with_one_arg`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:with_one_arg
      ------------------------------------------------------------
      My task with one argument.

      Set environment variable THE_ARG if you want to pass a Rake task argument.


      """

  Scenario: mirror Rake task 'my_namespace:in_a_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
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
          cape.mirror_rake_tasks
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

  Scenario: mirror Rake task 'with_two_args' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -e ns:with_two_args`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:with_two_args
      ------------------------------------------------------------
      My task with two arguments.

      Set environment variables MY_ARG1 and MY_ARG2 if you want to pass Rake task
      arguments.


      """

  Scenario: mirror Rake task 'with_three_args' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -e ns:with_three_args`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:with_three_args
      ------------------------------------------------------------
      My task with three arguments.

      Set environment variables AN_ARG1, AN_ARG2, and AN_ARG3 if you want to pass Rake
      task arguments.


      """

  Scenario: do not mirror Rake task 'hidden_task'
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -e ns:hidden_task`
    Then the output should contain exactly:
      """
      The task `ns:hidden_task' does not exist.

      """
