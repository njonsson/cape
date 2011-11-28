Feature: Invoking parameterless Rake tasks via Capistrano

  In order to invoke Rake tasks via Capistrano,
  As a developer using Cape,
  I want to use the `cap` command.

  Scenario: invoke Rake task 'with_period'
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
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
      """

  Scenario: invoke Rake task 'my_namespace:in_a_namespace'
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
      When I run `cap my_namespace:in_a_namespace`
    Then the output should contain:
      """
      * executing `my_namespace:in_a_namespace'
      """
