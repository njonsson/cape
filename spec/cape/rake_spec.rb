require 'cape/rake'

describe Cape::Rake do
  describe '::DEFAULT_EXECUTABLE' do
    subject { Cape::Rake::DEFAULT_EXECUTABLE }

    it { should == '/usr/bin/env rake' }

    it { should be_frozen }
  end

  describe '#==' do
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

  describe 'without specified attributes' do
    its(:local_executable)  { should == '/usr/bin/env rake' }

    its(:remote_executable) { should == '/usr/bin/env rake' }
  end

  describe 'with specified attributes' do
    subject { described_class.new :local_executable => 'And now for something',
                                  :remote_executable => 'completely different' }

    its(:local_executable)  { should == 'And now for something' }

    its(:remote_executable) { should == 'completely different' }
  end
end
