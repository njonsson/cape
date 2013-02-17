require 'cape/hash_list'
require 'cape/rake'
require 'cape/util'

module Cape

  # An abstraction of the Capistrano installation.
  class Capistrano

    # A Cape abstraction of the Rake installation.
    attr_accessor :rake

    # Constructs a new Capistrano object with the specified _attributes_.
    #
    # @param [Hash] attributes attribute values
    def initialize(attributes={})
      attributes.each do |name, value|
        send "#{name}=", value
      end
      self.rake ||= Rake.new
    end

    # Defines a wrapper in Capistrano around the specified Rake _task_.
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
    # @return [Capistrano] the object
    #
    # @raise [ArgumentError] +named_arguments[:binding]+ is missing
    #
    # @note Any parameters that the Rake task has are integrated via environment variables, since Capistrano does not support recipe parameters per se.
    #
    # @see http://github.com/capistrano/capistrano/blob/master/lib/capistrano/configuration/actions/invocation.rb#L99-L144 Valid Capistrano ‘task’ method options
    def define_rake_wrapper(task, named_arguments, &block)
      unless (binding = named_arguments[:binding])
        raise ::ArgumentError, ':binding named argument is required'
      end

      capistrano_context = binding.eval('self', __FILE__, __LINE__)
      options = named_arguments.reject do |key, value|
        key == :binding
      end
      describe  task, capistrano_context
      implement(task, capistrano_context, options, &block)
    end

  private

    def build_capistrano_description(task)
      return nil unless task[:description]

      description = [task[:description]]
      unless task[:description].empty? || task[:description].end_with?('.')
        description << '.'
      end

      unless (parameters = Array(task[:parameters])).empty?
        noun            = Util.pluralize('variable', parameters.length)
        parameters_list = Util.to_list_phrase(parameters.collect(&:upcase))
        singular        = 'Rake task argument'
        noun_phrase     = (parameters.length == 1) ?
                          "a #{singular}"          :
                          Util.pluralize(singular)
        description << <<-end_fragment


Set environment #{noun} #{parameters_list} if you want to pass #{noun_phrase}.
        end_fragment
      end

      description.join
    end

    def describe(task, capistrano_context)
      if (description = build_capistrano_description(task))
        capistrano_context.desc description
      end
      self
    end

    def implement(task, capistrano_context, options, &env_block)
      name_tokens = task[:name].split(':')
      name_tokens << 'default' if task[:default]
      rake = self.rake
      # Define the recipe.
      block = lambda { |context|
        context.task name_tokens.last, options do
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
          env_hash = HashList.new
          env_block.call(env_hash) if env_block
          env_hash.reject! do |var_name, var_value|
            var_name.nil? || var_value.nil?
          end
          env_strings = env_hash.collect do |var_name, var_value|
            "#{var_name}=#{var_value.inspect}"
          end
          env = env_strings.empty? ? nil : (' ' + env_strings.join(' '))
          command = "cd #{context.current_path} && " +
                    "#{rake.remote_executable} "     +
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

  end

end
