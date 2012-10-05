module Cape

  # An abstraction of the Rake installation and available tasks.
  class Rake

    # The default command used to run Rake. We use `bundle check` to detect the
    # presence of Bundler and a Bundler configuration. If Bundler is installed
    # on the computer and configured, we prepend `rake` with `bundle exec`.
    DEFAULT_EXECUTABLE = (
                          '/usr/bin/env '                                 +
                          '`'                                             +
                           '/usr/bin/env bundle check >/dev/null 2>&1; '  +
                           'case $? in '                                  +
                              # Exit code 0: bundle is defined and installed
                              # Exit code 1: bundle is defined but not installed
                             '0|1 ) '                                     +
                               'echo bundle exec '                        +
                               ';; '                                      +
                           'esac' +
                          '` '                                            +
                          'rake'
                         ).freeze

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
      each_output_line do |l|
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
          previous_task[:default] = (all_but_last_segment ==
                                     previous_task[:name])
          yield previous_task
        end
      end
      yield this_task if this_task
      self
    end

    # Forces cached Rake task metadata (if any) to be discarded.
    def expire_cache!
      @output_lines = nil
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

    # Sets the command used to run Rake on the local computer and discards any
    # cached Rake task metadata.
    #
    # @param [String] value the command used to run Rake on the local computer
    # @return [String] _value_
    #
    # @see #expire_cache!
    def local_executable=(value)
      unless @local_executable == value
        @local_executable = value
        expire_cache!
      end
      value
    end

    # The command used to run Rake on remote computers.
    #
    # @return [String] the command used to run Rake on remote computers
    #
    # @see DEFAULT_EXECUTABLE
    def remote_executable
      @remote_executable ||= DEFAULT_EXECUTABLE
    end

  private

    def each_output_line(&block)
      if @output_lines
        @output_lines.each(&block)
        return self
      end

      @output_lines = []
      begin
        fetch_output.each_line do |l|
          @output_lines << l
          block.call(l)
        end
      rescue
        expire_cache!
        raise
      end
      self
    end

    def fetch_output
      `#{local_executable} --tasks 2>/dev/null`
    end
  end

end
