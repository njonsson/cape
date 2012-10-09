require 'cape/capistrano'
require 'cape/deprecation/capistrano_deprecated_define_rake_wrapper'
require 'cape/recipe_definition_deprecated'
require 'cape/xterm'

module Cape

  # Implements {Capistrano} with deprecated methods.
  #
  # @api private
  class CapistranoDeprecated < Capistrano

    # Defines a wrapper in Capistrano around the specified Rake _task_.
    #
    # @deprecated Use {Capistrano#define_rake_wrapper} instead.
    #
    # @param [Hash] task            metadata for a Rake task
    # @param [Hash] named_arguments named arguments, including options to pass to
    #                               the Capistrano +task+ method
    #
    # @option task [String]               :name        the name of the Rake task
    # @option task [Array of String, nil] :parameters  the names of the Rake
    #                                                  task's parameters, if any
    # @option task [String]               :description documentation for the Rake
    #                                                  task
    #
    # @option named_arguments [Binding] :binding            the Binding of your
    #                                                       Capistrano recipes
    #                                                       file
    #
    # @yield [env] a block that defines environment variables for the Rake task;
    #              optional
    # @yieldparam [Hash] env the environment variables to set before executing
    #                        the Rake task
    #
    # @return [CapistranoDeprecated] the object
    #
    # @raise [ArgumentError] +named_arguments[:binding]+ is missing
    #
    # @note Any parameters that the Rake task has are integrated via environment variables, since Capistrano does not support recipe parameters per se.
    #
    # @see http://github.com/capistrano/capistrano/blob/master/lib/capistrano/configuration/actions/invocation.rb#L99-L144 Valid Capistrano 'task' method options
    #
    # @api public
    def define_rake_wrapper(task, named_arguments, &block)
      unless (binding = named_arguments[:binding])
        raise ::ArgumentError, ':binding named argument is required'
      end

      deprecation.task            = task
      deprecation.named_arguments = named_arguments

      capistrano_context = binding.eval('self', __FILE__, __LINE__)
      options = named_arguments.reject do |key, value|
        key == :binding
      end
      describe  task, capistrano_context
      implement(task, capistrano_context, options, &block)
    end

    # The object in which deprecated API usage is recorded.
    #
    # @return [Deprecation::Base]
    def deprecation
      @deprecation ||= Deprecation::CapistranoDeprecatedDefineRakeWrapper.new
    end

  private

    def capture_recipe_definition(recipe_definition, &recipe_definition_block)
      begin
        super
      rescue NoMethodError
        unless @warned
          deprecation.stream.puts XTerm.bold_and_foreground_red('*** DEPRECATED:') +
                                  ' '                                              +
                                  XTerm.bold('Referencing Capistrano variables '   +
                                             'from Cape without wrapping them in ' +
                                             'a block, a lambda, or another '      +
                                             'callable object')
          @warned = true
        end
        return false
      end
      true
    end

    def implement(task, capistrano_context, options, &env_block)
      return super(task, capistrano_context, &env_block) if options.empty?

      name_tokens = tokenize_name(task)
      recipe_definition = new_recipe_definition(deprecation)
      env = nil
      if capture_recipe_definition(recipe_definition, &env_block)
        env_strings = recipe_definition.env.collect do |var_name, var_value|
          if var_name.nil? || var_value.nil?
            nil
          else
            var_value = var_value.call if var_value.is_a?(Proc)
            "#{var_name}=#{var_value.inspect}"
          end
        end.compact
        env = env_strings.empty? ? nil : (' ' + env_strings.join(' '))
      end
      this = env ? nil : self
      rake = self.rake
      block = lambda { |context|
        recipe_name = name_tokens.last
        if recipe_definition.rename
          recipe_name = recipe_definition.rename.call(name_tokens.last)
        end
        context.task recipe_name, options do
          arguments = Array(task[:parameters]).collect do |a|
            if (value = ENV[a.upcase])
              value = value.inspect
            end
            value
          end
          if arguments.empty?
            arguments = nil
          else
            arguments = "[#{arguments.join ','}]"
          end

          unless env
            if this.instance_eval { capture_recipe_definition(recipe_definition, &env_block) }
              env_strings = recipe_definition.env.collect do |var_name, var_value|
                if var_name.nil? || var_value.nil?
                  nil
                else
                  var_value = var_value.call if var_value.is_a?(Proc)
                  "#{var_name}=#{var_value.inspect}"
                end
              end.compact
              env = env_strings.empty? ? nil : (' ' + env_strings.join(' '))
              this = nil
            end
          end

          path = recipe_definition.cd || context.current_path
          path = path.call if path.respond_to?(:call)
          command = "cd #{path} && #{rake.remote_executable} " +
                    "#{task[:name]}#{arguments}#{env}"
          context.run command
        end
      }
      # Nest the recipe inside its containing namespaces.
      name_tokens[0...-1].reverse.each do |namespace_token|
        inner_block = block
        block = lambda { |context|
          context.namespace(namespace_token, &inner_block)
        }
      end
      block.call capistrano_context
      self
    end

    def new_recipe_definition(*arguments)
      arguments << deprecation if arguments.empty?
      RecipeDefinitionDeprecated.new(*arguments)
    end

  end

end
