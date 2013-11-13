Feature: The #mirror_rake_tasks DSL method

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror all Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap long                                                   # My long task -- it has a ve...
      """
    And the output should contain:
      """
      cap with_one_arg                                           # My task with one argument.
      """
    And the output should contain:
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
    And the output should contain:
      """
      cap with_two_args                                          # My task with two arguments.
      """
    And the output should contain:
      """
      cap with_three_args                                        # My task with three arguments.
      """
    And the output should contain:
      """
      cap hidden_task                                            #
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

  Scenario: mirror Rake task 'long' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap long`
    Then the output should contain:
      """
        * executing `long'
      """
    And the output should contain:
      """
      `long' is only run for servers matching {}, but no servers matched
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

      Set environment variable THE_ARG if you want to pass a Rake task argument.


      """

  Scenario: mirror Rake task 'my_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap -e my_namespace`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap my_namespace
      ------------------------------------------------------------
      A task that shadows a namespace.


      """

  Scenario: mirror Rake task 'my_namespace' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap my_namespace`
    Then the output should contain:
      """
        * executing `my_namespace'
      """
    And the output should contain:
      """
      `my_namespace' is only run for servers matching {}, but no servers matched
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
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks
      end
      """
      When I run `cap my_namespace:my_nested_namespace:in_a_nested_namespace`
    Then the output should contain:
      """
        * executing `my_namespace:my_nested_namespace:in_a_nested_namespace'
      """
    And the output should contain:
      """
      `my_namespace:my_nested_namespace:in_a_nested_namespace' is only run for servers matching {}, but no servers matched
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

      Set environment variables MY_ARG1 and MY_ARG2 if you want to pass Rake task
      arguments.


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

      Set environment variables AN_ARG1, AN_ARG2, and AN_ARG3 if you want to pass Rake
      task arguments.


      """

  Scenario: mirror Rake task 'with_three_args' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap with_three_args AN_ARG1="a value for an_arg1" AN_ARG2="a value for an_arg2" AN_ARG3="a value for an_arg3"`
    Then the output should contain:
      """
        * executing `with_three_args'
      """
    And the output should contain:
      """
      `with_three_args' is only run for servers matching {}, but no servers matched
      """

  Scenario: mirror Rake task 'with_three_args' with its implementation not enforcing arguments
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap with_three_args AN_ARG2="a value for an_arg2"`
    Then the output should contain:
      """
        * executing `with_three_args'
      """
    And the output should contain:
      """
      `with_three_args' is only run for servers matching {}, but no servers matched
      """
