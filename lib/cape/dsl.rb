require 'cape/capistrano'
require 'cape/rake'

module Cape

  # Provides methods for integrating Capistrano and Rake.
  module DSL

    # Yields each available Rake task to a block. The optional _task_expression_
    # argument limits the list to a single task or a namespace containing
    # multiple tasks.
    #
    # Tasks are yielded as Hash objects of the form:
    #
    #   {:name        => <String>,
    #    :parameters  => <String Array or nil>,
    #    :description => <String>}
    def each_rake_task(task_expression=nil, &block)
      rake.each_task(task_expression, &block)
      self
    end

    # Returns the command used to run Rake on the local computer. Defaults to
    # Rake::DEFAULT_EXECUTABLE.
    def local_rake_executable
      rake.local_executable
    end

    # Sets the command used to run Rake on the local computer.
    def local_rake_executable=(value)
      rake.local_executable = value
    end

    # Defines each available Rake task as a Capistrano task. Any
    # parameters the tasks have are converted to environment variables, since
    # Capistrano does not have the concept of task parameters. The optional
    # _task_expression_ argument limits the list to a single task or a namespace
    # containing multiple tasks.
    def mirror_rake_tasks(task_expression=nil)
      d = nil
      rake.each_task task_expression do |t|
        (d ||= deployment_library).define t, :binding => binding, :rake => rake
      end
      self
    end

    # Returns the command used to run Rake on remote computers. Defaults to
    # Rake::DEFAULT_EXECUTABLE.
    def remote_rake_executable
      rake.remote_executable
    end

    # Sets the command used to run Rake on remote computers.
    def remote_rake_executable=(value)
      rake.remote_executable = value
    end

  private

    def deployment_library
      raise_unless_capistrano
      Capistrano.new
    end

    def method_missing(method, *args, &block)
      @outer_self.send(method, *args, &block)
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
