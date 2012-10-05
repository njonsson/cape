Feature: The #mirror_rake_tasks DSL method with arguments of a defined task and valid options, and with environment variables

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror all non-hidden Rake tasks with the specified options
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
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
    And the output should not contain "cap hidden_task"

  Scenario: mirror Rake task 'with_period' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
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
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period RAILS_ENV=\"production\""
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """

  Scenario: mirror Rake task 'with_period' with its implementation, ignoring nil environment variable names
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'
      set :rails_env,    'production'

      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env[nil] = 'foo'
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period"
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """

  Scenario: mirror Rake task 'with_period' with its implementation, ignoring nil environment variable values
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'
      set :rails_env,    'production'

      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['FOO'] = nil
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period"
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """

  Scenario: mirror Rake task 'with_one_arg' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
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

  Scenario: mirror Rake task 'my_namespace:in_a_namespace' with its description
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
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

  Scenario: mirror Rake task 'with_three_args' with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'
      set :rails_env,    'production'

      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
      end
      """
    When I run `cap with_three_args AN_ARG1="a value for an_arg1" AN_ARG2="a value for an_arg2" AN_ARG3="a value for an_arg3"`
    Then the output should contain:
      """
        * executing `with_three_args'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_three_args[\"a value for an_arg1\",\"a value for an_arg2\",\"a value for an_arg3\"] RAILS_ENV=\"production\""
      `with_three_args' is only run for servers matching {:roles=>:app}, but no servers matched
      """

  Scenario: mirror Rake task 'with_three_args' with its implementation not enforcing arguments
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'
      set :rails_env,    'production'

      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
      end
      """
    When I run `cap with_three_args AN_ARG2="a value for an_arg2"`
    Then the output should contain:
      """
        * executing `with_three_args'
        * executing "cd /path/to/current/deployed/application && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_three_args[,\"a value for an_arg2\",] RAILS_ENV=\"production\""
      `with_three_args' is only run for servers matching {:roles=>:app}, but no servers matched
      """

  Scenario: do not mirror Rake task 'hidden_task'
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :roles => :app do |env|
          env['RAILS_ENV'] = rails_env
        end
      end
      """
    When I run `cap -e hidden_task`
    Then the output should contain exactly:
      """
      The task `hidden_task' does not exist.

      """
