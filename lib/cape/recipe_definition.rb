require 'cape/hash_list'

module Cape

  # Determines how a Capistrano recipe will be defined.
  class RecipeDefinition

    # The remote directory from which Rake tasks will be executed.
    #
    # @overload cd
    #   The remote directory from which Rake tasks will be executed.
    #
    #   @return [String, Proc] the value or a block that returns the value
    #
    # @overload cd(path)
    #   Sets the remote directory from which Rake tasks will be executed.
    #
    #   @param [String, Proc] path the value or a callable object that returns
    #                              the value
    #
    #   @return [String, Proc] _path_
    #
    #   @raise [ArgumentError] _path_ is a callable object that has parameters
    #
    # @overload cd(&block)
    #   Sets the remote directory from which Rake tasks will be executed.
    #
    #   @yieldreturn [String] the value
    #
    #   @return [String, Proc] _block_
    #
    #   @raise [ArgumentError] _block_ has parameters
    def cd(path=nil, &block)
      if (cd = (path || block))
        if cd.respond_to?(:arity)
          case cd.arity
            when -1
              # Lambda: good
            when 0
              # Good
            else
              raise ::ArgumentError, "Must have 0 parameters but has #{cd.arity}"
          end
        end

        @cd = cd
      else
        @cd
      end
    end

    # A hash of remote environment variables.
    #
    # @return [HashList] the desired environment of the remote computer
    def env
      @env ||= HashList.new
    end

    # A hash of Capistrano recipe options to pass to the Capistrano +task+
    # method.
    #
    # @return [HashList] the desired Capistrano recipe options
    #
    # @see http://github.com/capistrano/capistrano/blob/master/lib/capistrano/configuration/actions/invocation.rb#L99-L144 Valid Capistrano 'task' method options
    def options
      @options ||= HashList.new
    end

    # How Rake tasks will be named when they are mirrored as Capistrano recipes.
    #
    # @overload rename
    #   How Rake tasks will be named when they are mirrored as Capistrano
    #   recipes.
    #
    #   @return [Proc] the block that generates a Capistrano recipe name from a
    #                  Rake task name
    #
    # @overload rename(&block)
    #   Determines how Rake tasks will be named when they are mirrored as
    #   Capistrano recipes.
    #
    #   @yield [task_name]
    #   @yieldparam task_name [String] the name of a Rake task
    #   @yieldreturn [String] a name for the Capistrano recipe
    #
    #   @return [Proc] _block_
    #
    #   @raise [ArgumentError] _block_ does not have exactly one parameter
    def rename(&block)
      if block
        unless (block.arity == 1)
          raise ::ArgumentError, "Must have 1 parameter but has #{block.arity}"
        end

        @rename = block
      else
        @rename
      end
    end

  end

end
