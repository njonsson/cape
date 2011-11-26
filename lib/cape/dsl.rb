require 'cape/capistrano'
require 'cape/rake'

module Cape

  # Provides methods for integrating Capistrano and Rake.
  module DSL

    # Enumerates Rake tasks.
    #
    # @param [String, Symbol] task_expression the full name of a task or
    #                                         namespace to filter; optional
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
    #       # * t[:description] -- documentation on the task, including parameters
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
    #       # * t[:description] -- documentation on the task, including parameters
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
    # @return [String] _value_
    #
    # @example Changing the local Rake executable
    #   require 'cape'
    #
    #   Cape do
    #     self.local_rake_executable = '/path/to/rake'
    #     $stdout.puts "We changed the local Rake executable to #{self.local_rake_executable.inspect}."
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
    # @return the result of the forwarded method call
    def method_missing(method, *args, &block)
      @outer_self.send(method, *args, &block)
    end

    # Defines Rake tasks as Capistrano recipes.
    #
    # @overload mirror_rake_tasks(task_expression=nil)
    #   Defines Rake tasks as Capistrano recipes.
    #
    #   @param [String, Symbol] task_expression the full name of a Rake task or
    #                                           namespace to filter; optional
    #
    #   @yield [env] a block that defines environment variables for the Rake
    #                task; optional
    #   @yieldparam [Hash] env the environment variables to set before executing
    #                          the Rake task
    #
    #   @return [DSL] the object
    #
    # @overload mirror_rake_tasks(capistrano_task_options={})
    #   Defines all Rake tasks as Capistrano recipes with options.
    #
    #   @param [Hash] capistrano_task_options options to pass to the Capistrano
    #                                         +task+ method; optional
    #
    #   @yield [env] a block that defines environment variables for the Rake
    #                task; optional
    #   @yieldparam [Hash] env the environment variables to set before executing
    #                          the Rake task
    #
    #   @return [DSL] the object
    #
    # @overload mirror_rake_tasks(task_expression, capistrano_task_options={})
    #   Defines specific Rake tasks as Capistrano recipes with options.
    #
    #   @param [String, Symbol] task_expression         the full name of a Rake
    #                                                   task or namespace to
    #                                                   filter
    #   @param [Hash]           capistrano_task_options options to pass to the
    #                                                   Capistrano +task+ method;
    #                                                   optional
    #
    #   @yield [env] a block that defines environment variables for the Rake
    #                task; optional
    #   @yieldparam [Hash] env the environment variables to set before executing
    #                          the Rake task
    #
    #   @return [DSL] the object
    #
    # @note Any parameters that the Rake tasks have are integrated via environment variables, since Capistrano does not support recipe parameters per se.
    #
    # @see http://github.com/capistrano/capistrano/blob/master/lib/capistrano/task_definition.rb#L15-L17 Valid Capistrano ‘task’ method options
    #
    # @example Mirroring all Rake tasks
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     mirror_rake_tasks
    #   end
    #
    # @example Mirroring specific Rake tasks
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     mirror_rake_tasks 'log:clear'
    #   end
    #
    # @example Mirroring specific Rake tasks with Capistrano recipe options and environment variables
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     mirror_rake_tasks :db, :roles => :app do |env|
    #       env['RAILS_ENV'] = rails_env
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
    def mirror_rake_tasks(*arguments, &block)
      arguments_count = arguments.length
      options = arguments.last.is_a?(Hash) ? arguments.pop.dup : {}
      unless arguments.length <= 1
        raise ::ArgumentError,
              "wrong number of arguments (#{arguments_count} for 0 or 1, plus " +
              'an options hash)'
      end

      task_expression = arguments.first
      options[:binding] = binding
      rake.each_task task_expression do |t|
        deployment_library.define_rake_wrapper(t, options, &block)
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
    # @return [String] _value_
    #
    # @example Changing the remote Rake executable
    #   require 'cape'
    #
    #   Cape do
    #     self.remote_rake_executable = '/path/to/rake'
    #     $stdout.puts "We changed the remote Rake executable to #{self.remote_rake_executable.inspect}."
    #   end
    def remote_rake_executable=(value)
      rake.remote_executable = value
    end

  private

    def deployment_library
      return @deployment_library if @deployment_library

      raise_unless_capistrano
      @deployment_library = Capistrano.new(:rake => rake)
    end

    def raise_unless_capistrano
      if @outer_self.method(:task).owner.name !~ /^Capistrano::/
        raise 'Use this in the context of Capistrano recipes'
      end
    end

    def rake
      @rake ||= Rake.new
    end

  end

end
