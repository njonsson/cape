Feature: The #mirror_rake_tasks DSL method with renaming logic, valid options, and a different directory

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror a Ruby-method-shadowing Rake task with its implementation
    Given a full-featured Rakefile defining a Ruby-method-shadowing task
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.rename do |task_name|
            "do_#{task_name}"
          end
          recipes.options[:roles] = :app
          recipes.cd { release_path }
        end
      end
      """
    When I run `cap do_load`
    Then the output should contain:
      """
        * executing `do_load'
      """
    And the output should contain:
      """
      `do_load' is only run for servers matching {:roles=>:app}, but no servers matched
      """
