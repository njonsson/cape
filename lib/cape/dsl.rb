require 'cape/capistrano'
require 'cape/rake'

module Cape

  # Provides methods for integrating Capistrano and Rake.
  module DSL

    # Enumerates Rake tasks.
    #
    # @param [String, Symbol] task_expression the full name of a task or
    #                                         namespace to filter
    # @param [Proc]           block           a block that processes tasks
    #
    # @yield [task] a block that processes tasks
    # @yieldparam [Hash] task metadata on a task
    #
    # @return [DSL] the object
    #
    # @example Enumerating all Rake tasks
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     each_rake_task do |t|
    #       # Do something interesting with this hash:
    #       # * t[:name] -- the full name of the task
    #       # * t[:parameters] -- the names of task arguments
    #       # * t[:description] -- documentation on the task, including
    #       #                      parameters
    #     end
    #   end
    #
    # @example Enumerating some Rake tasks
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     each_rake_task :foo do |t|
    #       # Do something interesting with this hash:
    #       # * t[:name] -- the full name of the task
    #       # * t[:parameters] -- the names of task arguments
    #       # * t[:description] -- documentation on the task, including
    #       #                      parameters
    #     end
    #   end
    def each_rake_task(task_expression=nil, &block)
      rake.each_task(task_expression, &block)
      self
    end

    # The command used to run Rake on the local computer.
    #
    # @return [String] the command used to run Rake on the local computer
    #
    # @see Rake::DEFAULT_EXECUTABLE
    def local_rake_executable
      rake.local_executable
    end

    # Sets the command used to run Rake on the local computer.
    #
    # @param [String] value the command used to run Rake on the local computer
    #
    # @return [String] _value_
    #
    # @example Changing the local Rake executable
    #   require 'cape'
    #
    #   Cape do
    #     self.local_rake_executable = '/path/to/rake'
    #     $stdout.puts 'We changed the local Rake executable to ' +
    #                  "#{local_rake_executable.inspect}."
    #   end
    def local_rake_executable=(value)
      rake.local_executable = value
    end

    # Makes the use of a Cape block parameter optional by forwarding non-Cape
    # method calls to the containing binding.
    #
    # @param [Symbol, String] method the method called
    # @param [Array]          args   the arguments passed to _method_
    # @param [Proc]           block  the block passed to _method_
    #
    # @return the result of the forwarded method call
    def method_missing(method, *args, &block)
      @outer_self.send(method, *args, &block)
    end

    # Defines Rake tasks as Capistrano recipes.
    #
    # @param [String, Symbol] task_expression the full name of a Rake task or
    #                                         namespace to filter
    #
    # @yield [recipes] a block that customizes the Capistrano recipe(s)
    #                  generated for the Rake task(s); optional
    # @yieldparam [RecipeDefinition] recipes an interface for customizing the
    #                                        Capistrano recipe(s) generated for
    #                                        the Rake task(s)
    #
    # @return [DSL] the object
    #
    # @note Any parameters that the Rake tasks have are integrated via environment variables, since Capistrano does not support recipe parameters per se.
    #
    # @example Mirroring all Rake tasks
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     # Create Capistrano recipes for all Rake tasks.
    #     mirror_rake_tasks
    #   end
    #
    # @example Mirroring some Rake tasks, but not others
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     # Create Capistrano recipes for the Rake task 'foo' and/or for the
    #     # tasks in the 'foo' namespace.
    #     mirror_rake_tasks :foo
    #   end
    #
    # @example Mirroring Rake tasks that require renaming, Capistrano recipe options, path switching, and/or environment variables
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     # Display defined Rails routes on application server remote machines
    #     # only.
    #     mirror_rake_tasks :routes do |recipes|
    #       recipes.options[:roles] = :app
    #     end
    #
    #     # Execute database migration on application server remote machines
    #     # only, and set the 'RAILS_ENV' environment variable to the value of
    #     # the Capistrano variable 'rails_env'.
    #     mirror_rake_tasks 'db:migrate' do |recipes|
    #       recipes.options[:roles] = :app
    #       recipes.env['RAILS_ENV'] = lambda { rails_env }
    #     end
    #
    #     # Support a Rake task that must be run on application server remote
    #     # machines only, and in the remote directory 'release_path' instead of
    #     # the default, 'current_path'.
    #     before 'deploy:symlink', :spec
    #     mirror_rake_tasks :spec do |recipes|
    #       recipes.cd { release_path }
    #       recipes.options[:roles] = :app
    #     end
    #
    #     # Avoid collisions with the existing Ruby method #test, run tests on
    #     # application server remote machines only, and set the 'RAILS_ENV'
    #     # environment variable to the value of the Capistrano variable
    #     # 'rails_env'.
    #     mirror_rake_tasks :test do |recipes|
    #       recipes.rename do |rake_task_name|
    #         "#{rake_task_name}_task"
    #       end
    #       recipes.options[:roles] = :app
    #       recipes.env['RAILS_ENV'] = lambda { rails_env }
    #     end
    #   end
    #
    # @example Mirroring Rake tasks into a Capistrano namespace
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   namespace :rake_tasks do
    #     Cape do |cape|
    #       cape.mirror_rake_tasks
    #     end
    #   end
    def mirror_rake_tasks(task_expression=nil, &block)
      rake.each_task task_expression do |t|
        deployment_library.define_rake_wrapper(t, :binding => binding, &block)
      end
      self
    end

    # The command used to run Rake on remote computers.
    #
    # @return [String] the command used to run Rake on remote computers
    #
    # @see Rake::DEFAULT_EXECUTABLE
    def remote_rake_executable
      rake.remote_executable
    end

    # Sets the command used to run Rake on remote computers.
    #
    # @param [String] value the command used to run Rake on remote computers
    #
    # @return [String] _value_
    #
    # @example Changing the remote Rake executable
    #   require 'cape'
    #
    #   Cape do
    #     self.remote_rake_executable = '/path/to/rake'
    #     $stdout.puts 'We changed the remote Rake executable to ' +
    #                  "#{remote_rake_executable.inspect}."
    #   end
    def remote_rake_executable=(value)
      rake.remote_executable = value
    end

  protected

    # Returns an abstraction of the Rake installation and available tasks.
    def rake
      @rake ||= new_rake
    end

  private

    def deployment_library
      return @deployment_library if @deployment_library

      raise_unless_capistrano
      @deployment_library = new_capistrano(:rake => rake)
    end

    def new_capistrano(*arguments)
      Capistrano.new(*arguments)
    end

    def new_rake(*arguments)
      Rake.new(*arguments)
    end

    def raise_unless_capistrano
      if @outer_self.method(:task).owner.name !~ /^Capistrano::/
        raise 'Use this in the context of Capistrano recipes'
      end
    end

  end

end
