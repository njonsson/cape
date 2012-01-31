module Cape

  # An abstraction of the Rake installation and available tasks.
  class Rake

    # The default command used to run Rake.
    DEFAULT_EXECUTABLE = '/usr/bin/env rake'.freeze

    # Sets the command used to run Rake on the local computer.
    #
    # @param [String] value the command used to run Rake on the local computer
    # @return [String] _value_
    attr_writer :local_executable

    # Sets the command used to run Rake on remote computers.
    #
    # @param [String] value the command used to run Rake on remote computers
    # @return [String] _value_
    attr_writer :remote_executable

    # Constructs a new Rake object with the specified _attributes_.
    def initialize(attributes={})
      attributes.each do |name, value|
        send "#{name}=", value
      end
    end

    # Compares the Rake object to another.
    #
    # @param [Object] other another object
    # @return [true]  the Rake object is equal to _other_
    # @return [false] the Rake object is unequal to _other_
    def ==(other)
      other.kind_of?(Rake)                          &&
      (other.local_executable  == local_executable) &&
      (other.remote_executable == remote_executable)
    end

    # Enumerates Rake tasks.
    #
    # @param [String, Symbol] task_expression the full name of a task or
    #                                         namespace to filter; optional
    # @param [Proc]           block           a block that processes tasks
    #
    # @yield [task] a block that processes tasks
    # @yieldparam [Hash] task metadata on a task
    #
    # @return [Rake] the object
    def each_task(task_expression=nil)
      previous_task, this_task = nil, nil
      task_expression = task_expression                       ?
                        ::Regexp.escape(task_expression.to_s) :
                        '.+?'
      regexp = /^rake (#{task_expression}(?::.+?)?)(?:\[(.+?)\])?\s+# (.+)/
      `#{local_executable} --tasks 2> /dev/null`.each_line do |l|
        unless (matches = l.chomp.match(regexp))
          next
        end

        previous_task = this_task
        this_task = {}.tap do |t|
          t[:name]        = matches[1].strip
          t[:parameters]  = matches[2].split(',') if matches[2]
          t[:description] = matches[3]
        end
        if previous_task
          all_but_last_segment = this_task[:name].split(':')[0...-1].join(':')
          if all_but_last_segment == previous_task[:name]
            previous_task[:name] << ':default'
          end
          yield previous_task
        end
      end
      yield this_task if this_task
      self
    end

    # The command used to run Rake on the local computer.
    #
    # @return [String] the command used to run Rake on the local computer
    #
    # @see DEFAULT_EXECUTABLE
    def local_executable
      @local_executable ||= DEFAULT_EXECUTABLE
    end

    # The command used to run Rake on remote computers.
    #
    # @return [String] the command used to run Rake on remote computers
    #
    # @see DEFAULT_EXECUTABLE
    def remote_executable
      @remote_executable ||= DEFAULT_EXECUTABLE
    end

  end

end
