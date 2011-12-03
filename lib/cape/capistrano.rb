require 'cape/strings'

module Cape

  # An abstraction of the Capistrano installation.
  class Capistrano

    # Defines the specified _task_ as a Capistrano task, provided a Binding
    # named argument +:binding+ and a Cape::Rake named argument +:rake+. Any
    # parameters the task has are converted to environment variables, since
    # Capistrano does not have the concept of task parameters.
    #
    # The _task_ argument must be a Hash of the form:
    #
    #   {:name        => <String>,
    #    :parameters  => <String Array or nil>,
    #    :description => <String>}
    def define(task, named_arguments={})
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
        noun            = Strings.pluralize('variable', parameters.length)
        parameters_list = Strings.to_list_phrase(parameters.collect(&:upcase))
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
