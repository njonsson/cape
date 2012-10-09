require 'cape/capistrano_deprecated'
require 'cape/deprecation/capistrano_deprecated_define_rake_wrapper'
require 'cape/deprecation/dsl_deprecated_mirror_rake_tasks'

module Cape

  # Implements deprecated methods of {DSL}.
  #
  # @api private
  module DSLDeprecated

    # The stream to which deprecation messages are printed.
    #
    # @return [Deprecation::Base]
    def deprecation
      @deprecation ||= Deprecation::DSLDeprecatedMirrorRakeTasks.new
    end

    # Defines Rake tasks as Capistrano recipes.
    #
    # @overload mirror_rake_tasks(task_expression=nil)
    #   Defines Rake tasks as Capistrano recipes.
    #
    #   @param [String, Symbol] task_expression the full name of a Rake task or
    #                                           namespace to filter
    #
    #   @yield [env] a block that defines environment variables for the Rake
    #                task; optional
    #   @yieldparam [RecipeDefinitionDeprecated] env the environment variables to
    #                                                set before executing the
    #                                                Rake task
    #
    #   @return [DSLDeprecated] the object
    #
    # @overload mirror_rake_tasks(capistrano_task_options={})
    #   Defines all Rake tasks as Capistrano recipes with options.
    #
    #   @deprecated Use {RecipeDefinition#options} instead.
    #
    #   @param [Hash] capistrano_task_options options to pass to the Capistrano
    #                                         +task+ method
    #
    #   @yield [env] a block that defines environment variables for the Rake
    #                task; optional
    #   @yieldparam [RecipeDefinitionDeprecated] env the environment variables to
    #                                                set before executing the
    #                                                Rake task
    #
    #   @return [DSLDeprecated] the object
    #
    # @overload mirror_rake_tasks(task_expression, capistrano_task_options={})
    #   Defines specific Rake tasks as Capistrano recipes with options.
    #
    #   @deprecated Use {RecipeDefinition#options} instead.
    #
    #   @param [String, Symbol] task_expression         the full name of a Rake
    #                                                   task or namespace to
    #                                                   filter
    #   @param [Hash]           capistrano_task_options options to pass to the
    #                                                   Capistrano +task+ method
    #
    #   @yield [env] a block that defines environment variables for the Rake
    #                task; optional
    #   @yieldparam [RecipeDefinitionDeprecated] env the environment variables to
    #                                                set before executing the
    #                                                Rake task
    #
    #   @return [DSLDeprecated] the object
    #
    # @note Any parameters that the Rake tasks have are integrated via environment variables, since Capistrano does not support recipe parameters per se.
    #
    # @see http://github.com/capistrano/capistrano/blob/master/lib/capistrano/configuration/actions/invocation.rb#L99-L144 Valid Capistrano 'task' method options
    #
    # @example Mirroring all Rake tasks
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     mirror_rake_tasks
    #   end
    #
    # @example Mirroring some Rake tasks, but not others
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     # Create Capistrano recipes for the Rake task 'foo' and/or for the
    #     # tasks in the 'foo' namespace.
    #     mirror_rake_tasks :foo
    #   end
    #
    # @example Mirroring Rake tasks that require Capistrano recipe options and/or environment variables
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   Cape do
    #     # Display defined Rails routes on application server remote machines
    #     # only.
    #     mirror_rake_tasks :routes, :roles => :app
    #
    #     # Execute database migration on application server remote machines
    #     # only, and set the 'RAILS_ENV' environment variable to the value of
    #     # the Capistrano variable 'rails_env'.
    #     mirror_rake_tasks 'db:migrate', :roles => :app do |env|
    #       env['RAILS_ENV'] = rails_env
    #     end
    #   end
    #
    # @example Mirroring Rake tasks into a Capistrano namespace
    #   # config/deploy.rb
    #
    #   require 'cape'
    #
    #   namespace :rake_tasks do
    #     Cape do |cape|
    #       cape.mirror_rake_tasks
    #     end
    #   end
    #
    # @api public
    def mirror_rake_tasks(*arguments, &block)
      arguments_count = arguments.length
      options = arguments.last.is_a?(::Hash) ? arguments.pop.dup : {}
      deprecation.task_expression = arguments.first
      deprecation.options = options.dup
      unless arguments.length <= 1
        raise ::ArgumentError,
              ("wrong number of arguments (#{arguments_count} for 0 or 1, " +
               'plus an options hash)')
      end

      task_expression = arguments.first
      options[:binding] = binding
      rake.each_task task_expression do |t|
        deployment_library.define_rake_wrapper(t, options, &block)
      end
      deployment_library.deprecation.env.each do |name, value|
        deprecation.env[name] = value
      end
      unless deprecation.options.empty? && deprecation.env.empty?
        deprecation.write_formatted_message_to_stream
      end
      self
    end

  private

    def new_capistrano(*arguments)
      CapistranoDeprecated.new(*arguments)
    end

  end

end
