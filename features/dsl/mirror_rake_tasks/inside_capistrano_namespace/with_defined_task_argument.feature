Feature: The #mirror_rake_tasks DSL method, inside a Capistrano namespace, with an argument of a defined task

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile
    And a file named "Capfile" with:
      """
      require 'cape'

      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks 'with_period'
        end
      end
      """
    When I run `cap -T`
    Then the output should contain:
      """
      cap ns:with_period # Ends with period.
      """
    And the output should not contain "cap ns:without_period"

  Scenario: mirror Rake task 'with_period' with its description
    Given a full-featured Rakefile
    And a file named "Capfile" with:
      """
      require 'cape'

      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks :with_period
        end
      end
      """
    When I run `cap -e ns:with_period`
    Then the output should contain exactly:
      """
      ------------------------------------------------------------
      cap ns:with_period
      ------------------------------------------------------------
      Ends with period.


      """

  Scenario: do not mirror Rake task 'without_period'
    Given a full-featured Rakefile
    And a file named "Capfile" with:
      """
      require 'cape'

      namespace :ns do
        Cape do |cape|
          cape.mirror_rake_tasks :with_period
        end
      end
      """
    When I run `cap -e ns:without_period`
    Then the output should contain exactly:
      """
      The task `ns:without_period' does not exist.

      """
