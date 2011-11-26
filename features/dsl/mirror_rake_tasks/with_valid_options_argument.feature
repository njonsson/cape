Feature: The #mirror_rake_tasks DSL method with arguments of a defined task and valid options, and with environment variables

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror all non-hidden Rake tasks with the specified options
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :roles => :app
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
        mirror_rake_tasks :roles => :app
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
      set :rails_env,    'production'

      Cape do
        mirror_rake_tasks :roles => :app
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env rake with_period"
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """
