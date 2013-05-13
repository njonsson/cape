require 'cape/deprecation/base'
require 'cape/hash_list'

module Cape

  module Deprecation

    # Prints to a stream a message related to deprecated usage of
    # {CapistranoDeprecated#define_rake_wrapper}.
    class CapistranoDeprecatedDefineRakeWrapper < Base

      # The _task_ argument to {CapistranoDeprecated#define_rake_wrapper}.
      #
      # @return [Symbol, String]
      attr_accessor :task

      # Environment variable names and values set in a call to
      # {CapistranoDeprecated#define_rake_wrapper}.
      #
      # @return [HashList]
      def env
        @env ||= HashList.new
      end

      # Prepares a message based on deprecated usage of
      # {CapistranoDeprecated#define_rake_wrapper}.
      #
      # @return [String] a deprecation message
      def message_content
        [].tap do |fragments|
          fragments << message_content_actual
          fragments << '. '
          fragments << message_content_expected
        end.join
      end

      # The _named_arguments_ argument to
      # {CapistranoDeprecated#define_rake_wrapper}.
      #
      # @return [HashList]
      def named_arguments
        @named_arguments ||= HashList.new
      end

      # Sets the value of {#named_arguments}.
      #
      # @param [Hash] value a new value for {#named_arguments}
      #
      # @return [HashList] _value_
      def named_arguments=(value)
        @named_arguments = HashList.new(value)
      end

    private

      def binding_named_arguments
        named_arguments.select do |name, value|
          name == :binding
        end
      end

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
          unless named_arguments.empty? && env.empty?
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
          fragments << message_content_task_and_named_arguments_actual
          fragments << message_content_env_actual
          fragments << '`'
        end.join
      end

      def message_content_expected
        [].tap do |fragments|
          fragments << 'Use this instead: '
          fragments << '`'
          fragments << message_content_method_name
          fragments << message_content_task_and_named_arguments_expected
          fragments << message_content_options_and_env_expected
          fragments << '`'
        end.join
      end

      def message_content_method_name
        'define_rake_wrapper'
      end

      def message_content_task_and_named_arguments_actual
        [].tap do |fragments|
          arguments = []
          arguments << task.inspect unless task.nil?
          named_arguments_entries = named_arguments.collect do |name, value|
            "#{name.inspect} => #{value.inspect}"
          end
          unless named_arguments_entries.empty?
            arguments << named_arguments_entries.join(', ')
          end
          unless arguments.empty?
            if env.empty?
              fragments << " #{arguments.join ', '}"
            else
              fragments << "(#{arguments.join ', '})"
            end
          end
        end.join
      end

      def message_content_task_and_named_arguments_expected
        [].tap do |fragments|
          arguments = []
          arguments << task.inspect unless task.nil?
          binding_named_arguments_entries = binding_named_arguments.collect do |name, value|
            "#{name.inspect} => #{value.inspect}"
          end
          unless binding_named_arguments_entries.empty?
            arguments << binding_named_arguments_entries.join(', ')
          end
          unless arguments.empty?
            if options.empty? && env.empty?
              fragments << " #{arguments.join ', '}"
            else
              fragments << "(#{arguments.join ', '})"
            end
          end
        end.join
      end

      def options
        named_arguments.reject do |name, value|
          name == :binding
        end
      end

    end

  end

end
