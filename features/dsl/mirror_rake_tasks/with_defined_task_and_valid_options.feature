Feature: The #mirror_rake_tasks DSL method with a defined task and valid options

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  @deprecated
  Scenario: mirror only the matching Rake task (deprecated)
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :long, :roles => :app
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap long   # My long task -- it has a very, very, very, very, very, very, ver...
      """
    And the output should not contain "with_one_arg"
    And the output should not contain "my_namespace"
    And the output should contain:
      """
      *** DEPRECATED: `mirror_rake_tasks :long, :roles => :app`. Use this instead: `mirror_rake_tasks(:long) { |recipes| recipes.options[:roles] = :app }`
      """

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :long do |recipes|
          recipes.options[:roles] = :app
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
    And the output should not contain "DEPRECATED"

  @deprecated
  Scenario: mirror the matching Rake task with its implementation (deprecated)
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks 'long', :roles => :app
      end
      """
    When I run `cap long`
    Then the output should contain:
      """
      *** DEPRECATED: `mirror_rake_tasks "long", :roles => :app`. Use this instead: `mirror_rake_tasks("long") { |recipes| recipes.options[:roles] = :app }`
        * executing `long'
      """
    And the output should contain:
      """
      `long' is only run for servers matching {:roles=>:app}, but no servers matched
      """

  Scenario: mirror the matching Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks 'long' do |recipes|
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
