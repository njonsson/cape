require 'cape/util'

module Cape

  # An abstraction of the Capistrano installation.
  class Capistrano

    # Defines the specified _task_ as a Capistrano task.
    #
    # @param [Hash] task            metadata for a task
    # @param [Hash] named_arguments named arguments
    #
    # @option task [String]               :name        the name of the task
    # @option task [Array of String, nil] :parameters  the names of the task's
    #                                                  parameters, if any
    # @option task [String]               :description documentation for the task
    #
    # @option named_arguments [Binding]           :binding the Binding of your
    #                                                      Capistrano recipes
    #                                                      file
    # @option named_arguments [Rake]              :rake    a Cape abstraction of
    #                                                      the Rake installation
    # @option named_arguments [[Array of] Symbol] :roles   the Capistrano role(s)
    #                                                      of remote computers
    #                                                      that will execute
    #                                                      _task_
    #
    # @return [Capistrano] the object
    #
    # @raise [ArgumentError] +named_arguments[:binding]+ is missing
    # @raise [ArgumentError] +named_arguments[:rake]+ is missing
    #
    # @note Any parameters that the task has are integrated via environment variables, since Capistrano does not support task parameters per se.
    def define(task, named_arguments)
      unless (binding = named_arguments[:binding])
        raise ::ArgumentError, ':binding named argument is required'
      end
      unless (rake = named_arguments[:rake])
        raise ::ArgumentError, ':rake named argument is required'
      end
      roles = named_arguments[:roles] || :app

      capistrano = binding.eval('self', __FILE__, __LINE__)
      if (description = build_capistrano_description(task))
        capistrano.desc description
      end
      implement task, roles, capistrano, rake
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
        description << <<-end_description


You must set environment #{noun} #{parameters_list}.
        end_description
      end
      description.join
    end

    def implement(task, roles, capistrano_context, rake)
      name = task[:name].split(':')
      # Define the task.
      block = lambda { |context|
        context.task name.last, :roles => roles do
          arguments = Array(task[:parameters]).collect do |a|
            unless (value = ENV[a.upcase])
              fail "Environment variable #{a.upcase} must be set"
            end
            value.inspect
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
      # Nest the task inside its containing namespaces.
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
