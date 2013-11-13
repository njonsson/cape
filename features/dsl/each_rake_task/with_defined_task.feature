Feature: The #each_rake_task DSL method with an argument of a defined task

  In order to use the metadata of Rake tasks in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: enumerate only the matching Rake task
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        each_rake_task 'long' do |t|
          $stdout.puts '', "Name: #{t[:name].inspect}"
          if t[:parameters]
            $stdout.puts "Parameters: #{t[:parameters].inspect}"
          end
          if t[:description]
            $stdout.puts "Description: #{t[:description].inspect}"
          end
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """

      Name: "long"
      Description: "My long task -- it has a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long description"
      """
    And the output should not contain "with_one_arg"
    And the output should not contain "my_namespace"
