Feature: The #mirror_rake_tasks DSL method with valid options and a different directory

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror a Rake task with its implementation
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.options[:roles] = :app
          recipes.cd { release_path }
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /release/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period"
      `with_period' is only run for servers matching {:roles=>:app}, but no servers matched
      """