Feature: The #local_rake_executable and #remote_rake_executable DSL attributes

  In order to control which Rake executables are used locally and remotely,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: use a different Rake executable to enumerate Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape.local_rake_executable = 'echo "rake this-comes-from-overridden-rake  # This comes from overridden Rake" #'

      Cape do
        $stdout.puts "We changed the local Rake executable to #{local_rake_executable.inspect}."
        $stdout.puts "We left the remote Rake executable as #{remote_rake_executable.inspect}."
        each_rake_task do |t|
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
    When I run `cap -T`
    Then the output should contain:
      """
      We changed the local Rake executable to "echo \"rake this-comes-from-overridden-rake  # This comes from overridden Rake\" #"
      """
    And the output should contain:
      """
      We left the remote Rake executable as "/usr/bin/env rake"
      """
    And the output should contain:
      """

      Name: "this-comes-from-overridden-rake"
      Description: "This comes from overridden Rake"
      """

  Scenario: use a different Rake executable to execute Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :current_path, '/path/to/current/deployed/application'

      Cape.remote_rake_executable = 'echo "This comes from overridden Rake" #'

      Cape do
        $stdout.puts "We changed the remote Rake executable to #{remote_rake_executable.inspect}."
        $stdout.puts "We left the local Rake executable as #{local_rake_executable.inspect}."
        mirror_rake_tasks
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
      We changed the remote Rake executable to "echo \"This comes from overridden Rake\" #"
      """
    And the output should contain:
      """
      We left the local Rake executable as "/usr/bin/env rake"
      """
    And the output should contain:
      """
        * executing `with_period'
        * executing "cd /path/to/current/deployed/application && echo \"This comes from overridden Rake\" # with_period"
      """
