Feature: The #mirror_rake_tasks DSL method with valid options

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror a Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.options[:roles] = :app
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
      """
    And the output should contain:
      """
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """
