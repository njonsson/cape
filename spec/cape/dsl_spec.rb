require 'cape/dsl'
require 'cape/capistrano'
require 'cape/core_ext/hash'
require 'cape/core_ext/symbol'
require 'cape/rake'

describe Cape::DSL do
  subject do
    Object.new.tap do |o|
      o.extend described_class
    end
  end

  let(:mock_capistrano) { mock(Cape::Capistrano).as_null_object }

  let(:mock_rake) { mock(Cape::Rake).as_null_object }

  let(:task_expression) { 'task:expression' }

  before :each do
    Cape::Capistrano.stub!(:new).and_return mock_capistrano
    Cape::Rake.      stub!(:new).and_return mock_rake
  end

  describe 'when sent #each_rake_task' do
    def do_each_rake_task(&block)
      subject.each_rake_task(task_expression, &block)
    end

    it 'should delegate to Rake#each_task' do
      mock_rake.should_receive(:each_task).
                with(task_expression).
                and_yield({:name => task_expression})
      do_each_rake_task do |t|
        t.should == {:name => task_expression}
      end
    end

    it 'should return itself' do
      do_each_rake_task.should == subject
    end
  end

  describe 'when sent #mirror_rake_tasks' do
    before :each do
      mock_rake.stub!(:each_task).and_yield({:name => task_expression})
      subject.stub! :raise_unless_capistrano
    end

    def do_mirror_rake_tasks(*arguments, &block)
      subject.mirror_rake_tasks(*arguments, &block)
    end

    describe 'with two scalar arguments' do
      specify do
        lambda {
          do_mirror_rake_tasks task_expression, task_expression
        }.should raise_error(ArgumentError,
                             'wrong number of arguments (2 for 0 or 1, plus ' +
                             'an options hash)')
      end
    end

    shared_examples_for 'a successful call' do |task_expression_in_use,
                                                options_in_use|
      it 'should collect Rake#each_task' do
        mock_rake.should_receive(:each_task).with task_expression_in_use
        do_mirror_rake_tasks
      end

      it 'should verify that Capistrano is in use' do
        subject.should_receive :raise_unless_capistrano
        do_mirror_rake_tasks
      end

      describe 'should Capistrano#define_rake_wrapper for Rake#each_task' do
        specify 'with the expected task' do
          mock_capistrano.should_receive(:define_rake_wrapper).with do |task,
                                                                        named_arguments|
            task == {:name => task_expression}
          end
          do_mirror_rake_tasks
        end

        specify 'with the expected named options' do
          mock_capistrano.should_receive(:define_rake_wrapper).with do |task,
                                                                        named_arguments|
            named_arguments.keys.sort == ([:binding] + options_in_use.keys).sort
          end
          do_mirror_rake_tasks
        end

        specify 'with a :binding option' do
          mock_capistrano.should_receive(:define_rake_wrapper).with do |task,
                                                                        named_arguments|
            named_arguments[:binding].is_a? Binding
          end
          do_mirror_rake_tasks
        end

        specify 'with any provided extra options' do
          mock_capistrano.should_receive(:define_rake_wrapper).with do |task,
                                                                        named_arguments|
            named_arguments.slice(*options_in_use.keys) == options_in_use
          end
          do_mirror_rake_tasks
        end
      end

      it 'should return itself' do
        do_mirror_rake_tasks.should == subject
      end
    end

    describe 'with one scalar argument, an options hash, and a block' do
      def do_mirror_rake_tasks
        super 'task:expression', :bar => :baz do |env|
          env['AN_ENV_VAR'] = 'an environment variable'
        end
      end

      it_should_behave_like 'a successful call', 'task:expression', :bar => :baz
    end

    describe 'with one scalar argument and an options hash' do
      def do_mirror_rake_tasks
        super 'task:expression', :bar => :baz
      end

      it_should_behave_like 'a successful call', 'task:expression', :bar => :baz
    end

    describe 'with an options hash and a block' do
      def do_mirror_rake_tasks
        super :bar => :baz do |env|
          env['AN_ENV_VAR'] = 'an environment variable'
        end
      end

      it_should_behave_like 'a successful call', nil, :bar => :baz
    end

    describe 'with an options hash' do
      def do_mirror_rake_tasks
        super :bar => :baz
      end

      it_should_behave_like 'a successful call', nil, :bar => :baz
    end

    describe 'with one scalar argument and a block' do
      def do_mirror_rake_tasks
        super 'task:expression' do |env|
          env['AN_ENV_VAR'] = 'an environment variable'
        end
      end

      it_should_behave_like('a successful call', 'task:expression', {})
    end

    describe 'with one scalar argument' do
      def do_mirror_rake_tasks
        super 'task:expression'
      end

      it_should_behave_like('a successful call', 'task:expression', {})
    end

    describe 'without arguments' do
      def do_mirror_rake_tasks
        super
      end

      it_should_behave_like('a successful call', nil, {})
    end
  end

  describe 'when sent #local_rake_executable' do
    before :each do
      mock_rake.stub!(:local_executable).and_return 'foo'
    end

    it 'should delegate to Rake#local_executable' do
      mock_rake.should_receive :local_executable
      subject.local_rake_executable
    end

    it 'should return the result of Rake#local_executable' do
      subject.local_rake_executable.should == 'foo'
    end
  end

  describe 'when sent #remote_rake_executable' do
    before :each do
      mock_rake.stub!(:remote_executable).and_return 'foo'
    end

    it 'should delegate to Rake#remote_executable' do
      mock_rake.should_receive :remote_executable
      subject.remote_rake_executable
    end

    it 'should return the result of Rake#remote_executable' do
      subject.remote_rake_executable.should == 'foo'
    end
  end
end
