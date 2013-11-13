Feature: The #mirror_rake_tasks DSL method with a different directory

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror a Rake task with its implementation, using a Capistrano variable inside a lambda
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.cd lambda { release_path }
        end
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

  Scenario: mirror a Rake task with its implementation, using a Capistrano variable inside a block
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.cd { release_path }
        end
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

  Scenario: mirror a Rake task with its implementation, using a string
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks do |recipes|
          recipes.cd '/release/path'
        end
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
