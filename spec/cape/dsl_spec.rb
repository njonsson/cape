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

    def do_mirror_rake_tasks
      subject.mirror_rake_tasks task_expression
    end

    it 'should collect Rake#each_task' do
      mock_rake.should_receive(:each_task).with task_expression
      do_mirror_rake_tasks
    end

    it 'should verify that Capistrano is in use' do
      subject.should_receive :raise_unless_capistrano
      do_mirror_rake_tasks
    end

    describe 'should Capistrano#define_rake_wrapper for Rake#each_task' do
      it 'with the expected task' do
        mock_capistrano.should_receive(:define_rake_wrapper).with do |task,
                                                                      options|
          task == {:name => task_expression}
        end
        do_mirror_rake_tasks
      end

      it 'with the expected named options' do
        mock_capistrano.should_receive(:define_rake_wrapper).with do |task,
                                                                      options|
          options.keys == [:binding]
        end
        do_mirror_rake_tasks
      end

      it 'with a :binding option' do
        mock_capistrano.should_receive(:define_rake_wrapper).with do |task,
                                                                      options|
          options[:binding].is_a? Binding
        end
        do_mirror_rake_tasks
      end
    end

    it 'should return itself' do
      do_mirror_rake_tasks.should == subject
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
