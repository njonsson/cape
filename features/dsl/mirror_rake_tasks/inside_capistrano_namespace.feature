Feature: The #mirror_rake_tasks DSL method, inside a Capistrano namespace

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror all Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap ns:with_period                                            # Ends with period.
      """

  Scenario: mirror a Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks
        end
      end
      """
    When I run `cap ns:with_period`
    Then the output should contain:
      """
        * executing `ns:with_period'
      """
