Feature: The #each_rake_task DSL method

  In order to use the metadata of Rake tasks in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: enumerate all Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        each_rake_task do |t|
          $stdout.puts '', "Name: #{t[:name].inspect}"
          if t[:parameters]
            $stdout.puts "Parameters: #{t[:parameters].inspect}"
          end
          if t[:description]
            $stdout.puts "Description: #{t[:description].inspect}"
          end
          $stdout.puts 'Default' if t[:default]
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """

      Name: "hidden_task"
      Description: ""

      Name: "long"
      Description: "My long task -- it has a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long description"

      Name: "my_namespace"
      Description: "A task that shadows a namespace"
      Default

      Name: "my_namespace:in_a_namespace"
      Description: "My task in a namespace"

      Name: "my_namespace:my_nested_namespace:in_a_nested_namespace"
      Description: "My task in a nested namespace"

      Name: "with_one_arg"
      Parameters: ["the_arg"]
      Description: "My task with one argument"

      Name: "with_period"
      Description: "Ends with period."

      Name: "with_three_args"
      Parameters: ["an_arg1", "an_arg2", "an_arg3"]
      Description: "My task with three arguments"

      Name: "with_two_args"
      Parameters: ["my_arg1", "my_arg2"]
      Description: "My task with two arguments"

      Name: "without_period"
      Description: "Ends without period"
      """
