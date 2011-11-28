Feature: Invoking parameterized Rake tasks via Capistrano

  In order to invoke Rake tasks via Capistrano,
  As a developer using Cape,
  I want to use the `cap` command.

  Scenario: invoke Rake task 'with_one_arg' without an argument
    Given a full-featured Rakefile
    And a file named "Capfile" with:
      """
      load 'deploy' if respond_to?(:namespace) # cap2 differentiator

      # Uncomment if you are using Rails' asset pipeline
      # load 'deploy/assets'

      Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

      load 'config/deploy' # remove this line to skip loading any of the default tasks
      require 'cape'

      Cape do
        mirror_rake_tasks
      end
      """
    And a file named "config/deploy.rb" with:
      """
      require 'cape'

      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap with_one_arg`
    Then the output should contain:
      """
        * executing `with_one_arg'
      """
    And the output should contain "Environment variable THE_ARG must be set (RuntimeError)"

  Scenario: invoke Rake task 'with_one_arg' with its argument
    Given a full-featured Rakefile
    And a file named "Capfile" with:
      """
      load 'deploy' if respond_to?(:namespace) # cap2 differentiator

      # Uncomment if you are using Rails' asset pipeline
      # load 'deploy/assets'

      Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

      load 'config/deploy' # remove this line to skip loading any of the default tasks
      require 'cape'

      Cape do
        mirror_rake_tasks
      end
      """
    And a file named "config/deploy.rb" with:
      """
      require 'cape'

      Cape do
        mirror_rake_tasks
      end
      """
    When I run `cap with_one_arg THE_ARG="the arg goes here"`
    Then the output should contain:
      """
        * executing `with_one_arg'
      """
