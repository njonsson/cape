require 'cape/deprecation/base'
require 'cape/hash_list'

module Cape

  module Deprecation

    # Prints to a stream a message related to deprecated usage of
    # {DSLDeprecated#mirror_rake_tasks}.
    class DSLDeprecatedMirrorRakeTasks < Base

      # The _task_expression_ argument to {DSLDeprecated#mirror_rake_tasks}.
      #
      # @return [Symbol, String]
      attr_accessor :task_expression

      # Environment variable names and values set in a call to
      # {DSLDeprecated#mirror_rake_tasks}.
      #
      # @return [HashList]
      def env
        @env ||= HashList.new
      end

      # Prepares a message based on deprecated usage of
      # {DSLDeprecated#mirror_rake_tasks}.
      #
      # @return [String] a deprecation message
      def message_content
        [].tap do |fragments|
          fragments << message_content_actual
          fragments << '. '
          fragments << message_content_expected
        end.join
      end

      # The _options_ argument to {DSLDeprecated#mirror_rake_tasks}.
      #
      # @return [HashList]
      def options
        @options ||= HashList.new
      end

      # Sets the value of {#options}.
      #
      # @param [Hash] value a new value for {#options}
      #
      # @return [HashList] _value_
      def options=(value)
        @options = HashList.new(value)
      end

    private

      def message_content_env_actual
        [].tap do |fragments|
          env_entries = env.collect do |name, value|
            "env[#{name.inspect}] = #{value.inspect}"
          end
          unless env_entries.empty?
            fragments << ' { |env| '
            fragments << env_entries.join('; ')
            fragments << ' }'
          end
        end.join
      end

      def message_content_options_and_env_expected
        [].tap do |fragments|
          unless options.empty? && env.empty?
            fragments << ' { |recipes| '

            options_entries = options.collect do |name, value|
              "recipes.options[#{name.inspect}] = #{value.inspect}"
            end
            env_entries = env.collect do |name, value|
              "recipes.env[#{name.inspect}] = #{value.inspect}"
            end
            fragments << (options_entries + env_entries).join('; ')

            fragments << ' }'
          end
        end.join
      end

      def message_content_actual
        [].tap do |fragments|
          fragments << '`'
          fragments << message_content_method_name
          fragments << message_content_task_expression_and_options_actual
          fragments << message_content_env_actual
          fragments << '`'
        end.join
      end

      def message_content_expected
        [].tap do |fragments|
          fragments << 'Use this instead: '
          fragments << '`'
          fragments << message_content_method_name
          fragments << message_content_task_expression_expected
          fragments << message_content_options_and_env_expected
          fragments << '`'
        end.join
      end

      def message_content_method_name
        'mirror_rake_tasks'
      end

      def message_content_task_expression_and_options_actual
        [].tap do |fragments|
          arguments = []
          arguments << task_expression.inspect unless task_expression.nil?
          options_entries = options.collect do |name, value|
            "#{name.inspect} => #{value.inspect}"
          end
          arguments << options_entries.join(', ') unless options_entries.empty?
          unless arguments.empty?
            if env.empty?
              fragments << " #{arguments.join ', '}"
            else
              fragments << "(#{arguments.join ', '})"
            end
          end
        end.join
      end

      def message_content_task_expression_expected
        [].tap do |fragments|
          unless task_expression.nil?
            if options.empty? && env.empty?
              fragments << " #{task_expression.inspect}"
            else
              fragments << "(#{task_expression.inspect})"
            end
          end
        end.join
      end

    end

  end

end
