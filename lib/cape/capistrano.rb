require 'cape/rake'
require 'cape/recipe_definition'
require 'cape/util'
require 'cape/xterm'

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
      self.rake ||= new_rake
    end

    # Defines a wrapper in Capistrano around the specified Rake _task_.
    #
    # @param [Hash] task            metadata for a Rake task
    # @param [Hash] named_arguments
    #
    # @option task [String]               :name        the name of the Rake task
    # @option task [Array of String, nil] :parameters  the names of the Rake
    #                                                  task's parameters, if any
    # @option task [String]               :description documentation for the Rake
    #                                                  task
    #
    # @option named_arguments [Binding] :binding the Binding of your Capistrano
    #                                            recipes file
    #
    # @yield [recipes] a block that customizes the Capistrano recipe(s)
    #                  generated for the Rake task(s); optional
    # @yieldparam [RecipeDefinition] recipes an interface for customizing the
    #                                        Capistrano recipe(s) generated for
    #                                        the Rake task(s)
    #
    # @return [Capistrano] the object
    #
    # @raise [ArgumentError] +named_arguments[:binding]+ is missing
    #
    # @note Any parameters that the Rake task has are integrated via environment variables, since Capistrano does not support recipe parameters per se.
    def define_rake_wrapper(task, named_arguments, &block)
      unless (binding = named_arguments[:binding])
        raise ::ArgumentError, ':binding named argument is required'
      end

      capistrano_context = binding.eval('self', __FILE__, __LINE__)
      describe  task, capistrano_context
      implement(task, capistrano_context, &block)
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

    def capture_recipe_definition(recipe_definition, &recipe_definition_block)
      recipe_definition_block.call(recipe_definition) if recipe_definition_block
      true
    end

    def describe(task, capistrano_context)
      if (description = build_capistrano_description(task))
        capistrano_context.desc description
      end
      self
    end

    def implement(task, capistrano_context, &recipe_definition_block)
      name_tokens = tokenize_name(task)
      recipe_definition = new_recipe_definition
      capture_recipe_definition(recipe_definition, &recipe_definition_block)
      env = nil
      rake = self.rake
      block = lambda { |context|
        recipe_name = name_tokens.last
        if recipe_definition.rename
          recipe_name = recipe_definition.rename.call(name_tokens.last)
        end
        begin
          context.task recipe_name, recipe_definition.options do
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
              env_strings = recipe_definition.env.collect do |var_name, var_value|
                if var_name.nil? || var_value.nil?
                  nil
                else
                  if var_value.is_a?(Proc)
                    var_value = context.instance_eval do
                      var_value.call
                    end
                  end
                  "#{var_name}=#{var_value.inspect}"
                end
              end.compact
              env = env_strings.empty? ? nil : (' ' + env_strings.join(' '))
            end

            path = recipe_definition.cd || context.current_path
            path = path.call if path.respond_to?(:call)
            command = "cd #{path} && #{rake.remote_executable} " +
                      "#{task[:name]}#{arguments}#{env}"
            context.run command
          end
        rescue => e
          $stderr.puts XTerm.bold_and_foreground_red('*** WARNING:')           +
                       ' '                                                     +
                       XTerm.bold("You must use Cape's renaming API in order " +
                                  'to mirror Rake task ')                      +
                       XTerm.bold_and_underlined(task[:name])                  +
                       XTerm.bold(" (#{e.message})")
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

    def new_rake(*arguments)
      Rake.new(*arguments)
    end

    def new_recipe_definition(*arguments)
      RecipeDefinition.new(*arguments)
    end

    def tokenize_name(task)
      task[:name].split(':').tap do |result|
        result << 'default' if task[:default]
      end
    end

  end

end
