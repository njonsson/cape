require 'cape/rake'
require 'cape/util'

module Cape

  # An abstraction of the Capistrano installation.
  class Capistrano

    # A Cape abstraction of the Rake installation.
    attr_accessor :rake

    # Constructs a new Capistrano object with the specified _attributes_.
    def initialize(attributes={})
      attributes.each do |name, value|
        send "#{name}=", value
      end
      self.rake ||= Rake.new
    end

    # Defines a wrapper in Capistrano around the specified Rake _task_.
    #
    # @param [Hash] task            metadata for a Rake task
    # @param [Hash] named_arguments named arguments
    #
    # @option task [String]               :name        the name of the Rake task
    # @option task [Array of String, nil] :parameters  the names of the Rake
    #                                                  task's parameters, if any
    # @option task [String]               :description documentation for the Rake
    #                                                  task
    #
    # @option named_arguments [Binding]           :binding the Binding of your
    #                                                      Capistrano recipes
    #                                                      file
    # @option named_arguments [[Array of] Symbol] :roles   the Capistrano role(s)
    #                                                      of remote computers
    #                                                      that will execute
    #                                                      _task_
    #
    # @return [Capistrano] the object
    #
    # @raise [ArgumentError] +named_arguments[:binding]+ is missing
    #
    # @note Any parameters that the Rake task has are integrated via environment variables, since Capistrano does not support recipe parameters per se.
    def define_rake_wrapper(task, named_arguments)
      unless (binding = named_arguments[:binding])
        raise ::ArgumentError, ':binding named argument is required'
      end
      roles = named_arguments[:roles] || :app

      capistrano_context = binding.eval('self', __FILE__, __LINE__)
      describe  task,        capistrano_context
      implement task, roles, capistrano_context
      self
    end

  private

    def build_capistrano_description(task)
      return nil unless task[:description]

      description = [task[:description]]
      description << '.' unless task[:description].end_with?('.')

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

    def implement(task, roles, capistrano_context)
      name = task[:name].split(':')
      rake = self.rake
      # Define the recipe.
      block = lambda { |context|
        context.task name.last, :roles => roles do
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
          context.run "cd #{context.current_path} && " +
                      "#{rake.remote_executable} #{name.join ':'}#{arguments}"
        end
      }
      # Nest the recipe inside its containing namespaces.
      name[0...-1].reverse.each do |namespace_token|
        inner_block = block
        block = lambda { |context|
          context.namespace(namespace_token, &inner_block)
        }
      end
      block.call capistrano_context
    end

  end

end
