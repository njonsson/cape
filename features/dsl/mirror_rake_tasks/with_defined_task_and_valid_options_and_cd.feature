Feature: The #mirror_rake_tasks DSL method with a defined task, valid options, and a different directory

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :long do |recipes|
          recipes.options[:roles] = :app
          recipes.cd { release_path }
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap long   # My long task -- it has a very, very, very, very, very, very, ver...
      """
    And the output should not contain "with_one_arg"
    And the output should not contain "my_namespace"

  Scenario: mirror the matching Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks :long do |recipes|
          recipes.options[:roles] = :app
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
      `long' is only run for servers matching {:roles=>:app}, but no servers matched
      """
