Feature: The #mirror_rake_tasks DSL method with a different directory and environment variables

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror a Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :release_path, '/release/path'
      set :rails_env,    'rails-env'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.cd { release_path }
          recipes.env['RAILS_ENV']  = lambda { rails_env }
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
