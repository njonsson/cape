Feature: The #each_rake_task DSL method with an argument of a defined namespace

  In order to use the metadata of Rake tasks in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: enumerate only the Rake tasks in the matching namespace
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        each_rake_task :my_namespace do |t|
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

      Name: "my_namespace"
      Description: "A task that shadows a namespace"
      Default

      Name: "my_namespace:in_a_namespace"
      Description: "My task in a namespace"

      Name: "my_namespace:my_nested_namespace:in_a_nested_namespace"
      Description: "My task in a nested namespace"
      """
    And the output should not contain "long"
