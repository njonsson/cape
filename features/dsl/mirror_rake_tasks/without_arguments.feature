Feature: The #mirror_rake_tasks DSL method without arguments

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror all non-hidden Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -T`
    Then the output should contain:
      """
      cap with_period                                            # Ends with period.
      """
    And the output should contain:
      """
      cap without_period                                         # Ends without period.
      """
    And the output should contain:
      """
      cap long                                                   # My long task -- it has a ve...
      """
    And the output should contain:
      """
      cap with_one_arg                                           # My task with one argument.
      """
    And the output should contain:
      """
      cap my_namespace:in_a_namespace                            # My task in a namespace.
      """
    And the output should contain:
      """
      cap my_namespace:my_nested_namespace:in_a_nested_namespace # My task in a nested namespace.
      """
    And the output should contain:
      """
      cap with_two_args                                          # My task with two arguments.
      """
    And the output should contain:
      """
      cap with_three_args                                        # My task with three arguments.
      """
    And the output should not contain "cap hidden_task"

  Scenario: mirror Rake task 'with_period' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
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

  Scenario: mirror Rake task 'with_period' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'

      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing "cd /path/to/current/deployed/application && /usr/bin/env rake with_period"
      """

  Scenario: mirror Rake task 'without_period' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -e without_period`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap without_period
      ------------------------------------------------------------
      Ends without period.


      """

  Scenario: mirror Rake task 'long' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -e long`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap long
      ------------------------------------------------------------
      My long task -- it has a very, very, very, very, very, very, very, very, very,
      very, very, very, very, very, very, very, very, very, very, very, very, very,
      very, very, very, very long description.


      """

  Scenario: mirror Rake task 'with_one_arg' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -e with_one_arg`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap with_one_arg
      ------------------------------------------------------------
      My task with one argument.

      You must set environment variable THE_ARG.


      """

  Scenario: mirror Rake task 'my_namespace:in_a_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
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
        mirror_rake_tasks
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

  Scenario: mirror Rake task 'my_namespace:my_nested_namespace:in_a_nested_namespace' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'

      Cape do
        mirror_rake_tasks
      end
      """
      When I run `cap my_namespace:my_nested_namespace:in_a_nested_namespace`
    Then the output should contain:
      """
      * executing "cd /path/to/current/deployed/application && /usr/bin/env rake my_namespace:my_nested_namespace:in_a_nested_namespace"
      """

  Scenario: mirror Rake task 'with_two_args' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -e with_two_args`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap with_two_args
      ------------------------------------------------------------
      My task with two arguments.

      You must set environment variables MY_ARG1 and MY_ARG2.


      """

  Scenario: mirror Rake task 'with_three_args' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -e with_three_args`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap with_three_args
      ------------------------------------------------------------
      My task with three arguments.

      You must set environment variables AN_ARG1, AN_ARG2, and AN_ARG3.


      """

  Scenario: mirror Rake task 'with_three_args' with its implementation enforcing arguments
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap with_three_args AN_ARG1="a value for an_arg1"`
    Then the output should contain "Environment variable AN_ARG2 must be set (RuntimeError)"

  Scenario: mirror Rake task 'with_three_args' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'

      Cape do
        mirror_rake_tasks
      end
      """
      When I run `cap with_three_args AN_ARG1="a value for an_arg1" AN_ARG2="a value for an_arg2" AN_ARG3="a value for an_arg3"`
    Then the output should contain:
      """
        * executing `with_three_args'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env rake with_three_args[\"a value for an_arg1\",\"a value for an_arg2\",\"a value for an_arg3\"]"

      """

  Scenario: do not mirror Rake task 'hidden_task'
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -e hidden_task`
    Then the output should contain exactly:
      """
      The task `hidden_task' does not exist.

      """
