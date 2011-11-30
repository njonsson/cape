Feature: The #mirror_rake_tasks DSL method, inside a Capistrano namespace, with an undefined argument

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: do not mirror any Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks 'this_does_not_exist'
        end
      end
      """
    When I run `cap -T`
    Then the output should not contain "cap ns:with_period"

  Scenario: do not mirror Rake task 'with_period'
    Given a full-featured Rakefile
    And a Capfile with:
      """
      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks :this_does_not_exist
        end
      end
      """
    When I run `cap -e ns:with_period`
    Then the output should contain exactly:
      """
      The task `ns:with_period' does not exist.

      """
