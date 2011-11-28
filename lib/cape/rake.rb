module Cape

  # An abstraction of the Rake installation and available tasks.
  class Rake

    # The default command used to run Rake.
    DEFAULT_EXECUTABLE = '/usr/bin/env rake'.freeze

    # Sets the command used to run Rake on the local computer.
    attr_writer :local_executable

    # Sets the command used to run Rake on remote computers.
    attr_writer :remote_executable

    # Constructs a new Rake object with the specified _attributes_.
    def initialize(attributes={})
      attributes.each do |name, value|
        send "#{name}=", value
      end
    end

    # Yields each available Rake task to a block. The optional _task_expression_
    # argument limits the list to a single task or a namespace containing
    # multiple tasks.
    #
    # Tasks are yielded as Hash objects of the form:
    #
    #   {:name        => <String>,
    #    :parameters  => <String Array or nil>,
    #    :description => <String>}
    def each_task(task_expression=nil)
      task_expression = " #{task_expression}" if task_expression
      command = "#{local_executable} --tasks #{task_expression}"
      `#{command}`.each_line do |l|
        matches = l.chomp.match(/^rake (.+?)(?:\[(.+?)\])?\s+# (.+)/)
        task = {}.tap do |t|
          t[:name]        = matches[1].strip
          t[:parameters]  = matches[2].split(',') if matches[2]
          t[:description] = matches[3]
        end
        yield task
      end
      self
    end

    # Returns the command used to run Rake on the local computer. Defaults to
    # DEFAULT_EXECUTABLE.
    def local_executable
      @local_executable ||= DEFAULT_EXECUTABLE
    end

    # Returns the command used to run Rake on remote computers. Defaults to
    # DEFAULT_EXECUTABLE.
    def remote_executable
      @remote_executable ||= DEFAULT_EXECUTABLE
    end

  end

end
