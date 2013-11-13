Feature: The #mirror_rake_tasks DSL method with valid options

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  @deprecated
  Scenario: mirror a Rake task with its implementation (deprecated)
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks :roles => :app
      end
      """
    When I run `cap long`
    Then the output should contain:
      """
      *** DEPRECATED: `mirror_rake_tasks :roles => :app`. Use this instead: `mirror_rake_tasks { |recipes| recipes.options[:roles] = :app }`
        * executing `long'
      """
    And the output should contain:
      """
      `long' is only run for servers matching {:roles=>:app}, but no servers matched
      """

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
    When I run `cap long`
    Then the output should contain:
      """
        * executing `long'
      """
    And the output should contain:
      """
      `long' is only run for servers matching {:roles=>:app}, but no servers matched
      """
    And the output should not contain "DEPRECATED"
