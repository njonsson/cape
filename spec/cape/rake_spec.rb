require 'cape/rake'

describe Cape::Rake do
  describe '::DEFAULT_EXECUTABLE' do
    subject { Cape::Rake::DEFAULT_EXECUTABLE }

    it { should == '/usr/bin/env rake' }

    it { should be_frozen }
  end

  describe '-- when sent #== --' do
    it('should recognize equivalent instances to be equal') {
      described_class.new.should == described_class.new
    }

    it('should compare using #local_executable') {
      described_class.new.should_not == described_class.new(:local_executable => 'foo')
    }

    it('should compare using #remote_executable') {
      described_class.new.should_not == described_class.new(:remote_executable => 'foo')
    }
  end

  describe '-- without specified attributes --' do
    its(:local_executable)  { should == '/usr/bin/env rake' }

    its(:remote_executable) { should == '/usr/bin/env rake' }
  end

  describe '-- with specified attributes --' do
    subject {
      described_class.new :local_executable => 'the specified value of #local_executable',
                          :remote_executable => 'the specified value of #remote_executable'
    }

    its(:local_executable) {
      should == 'the specified value of #local_executable'
    }

    its(:remote_executable) {
      should == 'the specified value of #remote_executable'
    }
  end

  describe '-- with respect to caching --' do
    before :each do
      subject.stub!(:fetch_output).and_return output
    end

    let(:output) {
      <<-end_output
rake foo # foo
rake bar # bar
rake baz # baz
      end_output
    }

    describe 'when sent #each_task,' do
      it 'should build and use a cache' do
        subject.should_receive(:fetch_output).once.and_return output
        subject.each_task do |t|
        end
        subject.each_task do |t|
        end
      end

      it 'should not expire the cache' do
        subject.should_not_receive :expire_cache!
        subject.each_task do |t|
        end
      end

      it 'should expire the cache in the event of an error' do
        subject.should_receive(:expire_cache!).once
        begin
          subject.each_task do |t|
            raise 'pow!'
          end
        rescue
        end
      end

      it 'should not swallow errors' do
        lambda {
          subject.each_task do |t|
            raise ZeroDivisionError, 'pow!'
          end
        }.should raise_error(ZeroDivisionError, 'pow!')
      end
    end

    describe 'when sent #expire_cache!,' do
      it 'should expire the cache' do
        subject.should_receive(:fetch_output).twice.and_return output
        subject.each_task do |t|
        end
        subject.expire_cache!
        subject.each_task do |t|
        end
      end
    end

    describe 'when sent #local_executable=' do
      describe 'with the same value,' do
        it 'should not expire the cache' do
          subject.should_not_receive :expire_cache!
          subject.local_executable = subject.local_executable
        end
      end

      describe 'with a different value,' do
        it 'should expire the cache' do
          subject.should_receive(:expire_cache!).once
          subject.local_executable = subject.local_executable + ' foo'
        end
      end
    end
  end
end
