require 'spec_helper'
require 'cape/dsl'
require 'cape/dsl_deprecated'
require 'cape/capistrano'
require 'cape/core_ext/hash'
require 'cape/core_ext/symbol'
require 'cape/rake'
require 'cape/xterm'

describe Cape::DSLDeprecated do
  subject(:dsl) do
    Object.new.tap do |o|
      o.extend Cape::DSL
      o.extend dsl_module
    end
  end

  let(:dsl_module) { described_class }

  let(:capistrano) { double(Cape::Capistrano).as_null_object }

  let(:rake) { double(Cape::Rake).as_null_object }

  let(:task_expression) { 'task:expression' }

  before :each do
    allow(Cape::Capistrano).to receive(:new).and_return(capistrano)
    allow(Cape::Rake      ).to receive(:new).and_return(rake)
    dsl.deprecation.stream = StringIO.new
  end

  describe '#each_rake_task' do
    def do_each_rake_task(&block)
      dsl.each_rake_task(task_expression, &block)
    end

    it 'delegates to Rake#each_task' do
      expect(rake).to receive(:each_task).
                      with(task_expression).
                      and_yield({:name => task_expression})
      do_each_rake_task do |t|
        expect(t).to eq(:name => task_expression)
      end
    end

    it 'returns itself' do
      expect(do_each_rake_task).to eq(dsl)
    end
  end

  describe '#mirror_rake_tasks' do
    before :each do
      allow(rake).to receive(:each_task).and_yield({:name => task_expression})
      allow(dsl ).to receive(:raise_unless_capistrano)
    end

    def do_mirror_rake_tasks(*arguments, &block)
      dsl.mirror_rake_tasks(*arguments, &block)
    end

    let(:deprecation_preamble) {
      Cape::XTerm.bold_and_foreground_red('*** DEPRECATED:') + ' '
    }

    describe 'with two scalar arguments --' do
      specify do
        expect {
          do_mirror_rake_tasks task_expression, task_expression
        }.to raise_error(ArgumentError,
                         'wrong number of arguments (2 for 0 or 1, plus ' +
                         'an options hash)')
      end
    end

    shared_examples_for "a successful call (#{Cape::DSLDeprecated.name})" do |task_expression_in_use,
                                                                              options_in_use|
      specify 'by collecting Rake#each_task' do
        expect(rake).to receive(:each_task).with(task_expression_in_use)
        do_mirror_rake_tasks
      end

      specify 'by verifying that Capistrano is in use' do
        expect(dsl).to receive(:raise_unless_capistrano)
        do_mirror_rake_tasks
      end

      describe 'by sending Capistrano#define_rake_wrapper for Rake#each_task' do
        specify 'with the expected task' do
          expect(capistrano).to receive(:define_rake_wrapper).
                                with { |task, named_arguments| task == {:name => task_expression} }
          do_mirror_rake_tasks
        end

        specify 'with the expected named options' do
          expect(capistrano).to receive(:define_rake_wrapper).
                                with { |task, named_arguments| named_arguments.keys.sort == ([:binding] + options_in_use.keys).sort }
          do_mirror_rake_tasks
        end

        specify 'with a :binding option' do
          expect(capistrano).to receive(:define_rake_wrapper).
                                with { |task, named_arguments| named_arguments[:binding].is_a? Binding }
          do_mirror_rake_tasks
        end

        specify 'with any provided extra options' do
          expect(capistrano).to receive(:define_rake_wrapper).
                                with { |task, named_arguments| named_arguments.slice(*options_in_use.keys) == options_in_use }
          do_mirror_rake_tasks
        end
      end

      specify 'by returning itself' do
        expect(do_mirror_rake_tasks).to eq(dsl)
      end
    end

    describe 'with one scalar argument, an options hash, and a block --' do
      def do_mirror_rake_tasks
        super 'task:expression', :bar => :baz do |env|
          env['AN_ENV_VAR'] = 'an environment variable'
        end
      end

      behaves_like "a successful call (#{Cape::DSLDeprecated.name})",
                   'task:expression',
                   :bar => :baz

      it 'prints the expected deprecation messages to stderr' do
        do_mirror_rake_tasks
        expect(dsl.deprecation.stream.string).to eq(deprecation_preamble                                                  +
                                                        Cape::XTerm.bold('`'                                                  +
                                                                          'mirror_rake_tasks "task:expression", '             +
                                                                                            ':bar => :baz'                    +
                                                                         '`. '                                                +
                                                                         'Use this instead: '                                 +
                                                                         '`'                                                  +
                                                                          'mirror_rake_tasks("task:expression") { |recipes| ' +
                                                                            'recipes.options[:bar] = :baz '                   +
                                                                          '}'                                                 +
                                                                         '`')                                                 +
                                                        "\n")
      end
    end

    describe 'with one scalar argument and an options hash --' do
      def do_mirror_rake_tasks
        super 'task:expression', :bar => :baz
      end

      behaves_like "a successful call (#{Cape::DSLDeprecated.name})",
                   'task:expression',
                   :bar => :baz

      it 'prints the expected deprecation messages to stderr' do
        do_mirror_rake_tasks
        expect(dsl.deprecation.stream.string).to eq(deprecation_preamble                                                  +
                                                        Cape::XTerm.bold('`'                                                  +
                                                                          'mirror_rake_tasks "task:expression", '             +
                                                                                            ':bar => :baz'                    +
                                                                         '`. '                                                +
                                                                         'Use this instead: '                                 +
                                                                         '`'                                                  +
                                                                          'mirror_rake_tasks("task:expression") { |recipes| ' +
                                                                            'recipes.options[:bar] = :baz '                   +
                                                                          '}'                                                 +
                                                                         '`')                                                 +
                                                        "\n")
      end
    end

    describe 'with an options hash and a block --' do
      def do_mirror_rake_tasks
        super :bar => :baz do |env|
          env['AN_ENV_VAR'] = 'an environment variable'
        end
      end

      behaves_like "a successful call (#{Cape::DSLDeprecated.name})",
                   nil,
                   :bar => :baz

      it 'prints the expected deprecation messages to stderr' do
        do_mirror_rake_tasks
        expect(dsl.deprecation.stream.string).to eq(deprecation_preamble                                +
                                                        Cape::XTerm.bold('`'                                +
                                                                          'mirror_rake_tasks :bar => :baz'  +
                                                                         '`. '                              +
                                                                         'Use this instead: '               +
                                                                         '`'                                +
                                                                          'mirror_rake_tasks { |recipes| '  +
                                                                            'recipes.options[:bar] = :baz ' +
                                                                          '}'                               +
                                                                         '`')                               +
                                                        "\n")
      end
    end

    describe 'with an options hash --' do
      def do_mirror_rake_tasks
        super :bar => :baz
      end

      behaves_like "a successful call (#{Cape::DSLDeprecated.name})",
                   nil,
                   :bar => :baz

      it 'prints the expected deprecation messages to stderr' do
        do_mirror_rake_tasks
        expect(dsl.deprecation.stream.string).to eq(deprecation_preamble                                +
                                                        Cape::XTerm.bold('`'                                +
                                                                          'mirror_rake_tasks :bar => :baz'  +
                                                                         '`. '                              +
                                                                         'Use this instead: '               +
                                                                         '`'                                +
                                                                          'mirror_rake_tasks { |recipes| '  +
                                                                            'recipes.options[:bar] = :baz ' +
                                                                          '}'                               +
                                                                         '`')                               +
                                                        "\n")
      end
    end

    describe 'with one scalar argument and a block --' do
      def do_mirror_rake_tasks
        super 'task:expression' do |env|
          env['AN_ENV_VAR'] = 'an environment variable'
        end
      end

      behaves_like("a successful call (#{Cape::DSLDeprecated.name})",
                   'task:expression',
                   {})

      it 'prints no deprecation messages to stderr' do
        do_mirror_rake_tasks
        expect(dsl.deprecation.stream.string).to be_empty
      end
    end

    describe 'with one scalar argument --' do
      def do_mirror_rake_tasks
        super 'task:expression'
      end

      behaves_like("a successful call (#{Cape::DSLDeprecated.name})",
                   'task:expression',
                   {})

      it 'prints no deprecation messages to stderr' do
        do_mirror_rake_tasks
        expect(dsl.deprecation.stream.string).to be_empty
      end
    end

    describe 'without arguments --' do
      def do_mirror_rake_tasks
        super
      end

      behaves_like("a successful call (#{Cape::DSLDeprecated.name})",
                   nil,
                   {})

      it 'prints no deprecation messages to stderr' do
        do_mirror_rake_tasks
        expect(dsl.deprecation.stream.string).to be_empty
      end
    end
  end

  describe '#local_rake_executable' do
    before :each do
      allow(rake).to receive(:local_executable).and_return('foo')
    end

    it 'delegates to Rake#local_executable' do
      expect(rake).to receive(:local_executable)
      dsl.local_rake_executable
    end

    it 'returns the result of Rake#local_executable' do
      expect(dsl.local_rake_executable).to eq('foo')
    end
  end

  describe '#remote_rake_executable' do
    before :each do
      allow(rake).to receive(:remote_executable).and_return('foo')
    end

    it 'delegates to Rake#remote_executable' do
      expect(rake).to receive(:remote_executable)
      dsl.remote_rake_executable
    end

    it 'returns the result of Rake#remote_executable' do
      expect(dsl.remote_rake_executable).to eq('foo')
    end
  end
end
