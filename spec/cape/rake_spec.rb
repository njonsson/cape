require 'spec_helper'
require 'cape/rake'

describe Cape::Rake do
  subject(:rake) { rake_class.new }

  let(:rake_class) { described_class }

  describe '::DEFAULT_EXECUTABLE' do
    subject(:constant) { rake_class::DEFAULT_EXECUTABLE }

    specify { expect(constant).to be_frozen }
  end

  describe '#==' do
    it('recognizes equivalent instances to be equal') {
      expect(rake_class.new).to eq(rake_class.new)
    }

    it('compares using #local_executable') {
      expect(rake_class.new).not_to eq(rake_class.new(:local_executable => 'foo'))
    }

    it('compares using #remote_executable') {
      expect(rake_class.new).not_to eq(rake_class.new(:remote_executable => 'foo'))
    }
  end

  describe '-- without specified attributes --' do
    describe '#local_executable' do
      specify { expect(rake.local_executable).to eq(rake_class::DEFAULT_EXECUTABLE) }
    end

    describe '#remote_executable' do
      specify { expect(rake.remote_executable).to eq(rake_class::DEFAULT_EXECUTABLE) }
    end
  end

  describe '-- with specified attributes --' do
    subject(:rake) {
      rake_class.new :local_executable => ('the specified value of ' +
                                           '#local_executable'),
                     :remote_executable => ('the specified value of ' +
                                            '#remote_executable')
    }

    describe '#local_executable' do
      specify { expect(rake.local_executable).to eq('the specified value of #local_executable') }
    end

    describe '#remote_executable' do
      specify { expect(rake.remote_executable).to eq('the specified value of #remote_executable') }
    end
  end

  describe '-- with respect to caching --' do
    before :each do
      allow(rake).to receive(:fetch_output).and_return(output)
    end

    let(:output) {
      <<-end_output
rake foo # foo
rake bar # bar
rake baz # baz
      end_output
    }

    describe '#each_task' do
      it 'builds and uses a cache' do
        expect(rake).to receive(:fetch_output).once.and_return(output)
        rake.each_task do |t|
        end
        rake.each_task do |t|
        end
      end

      it 'does not expire the cache' do
        expect(rake).not_to receive(:expire_cache!)
        rake.each_task do |t|
        end
      end

      it 'expires the cache in the event of an error' do
        expect(rake).to receive(:expire_cache!).once
        begin
          rake.each_task do |t|
            raise 'pow!'
          end
        rescue
        end
      end

      it 'does not swallow errors' do
        expect {
          rake.each_task do |t|
            raise ZeroDivisionError, 'pow!'
          end
        }.to raise_error(ZeroDivisionError, 'pow!')
      end
    end

    describe '#expire_cache!' do
      it 'expires the cache' do
        expect(rake).to receive(:fetch_output).twice.and_return(output)
        rake.each_task do |t|
        end
        rake.expire_cache!
        rake.each_task do |t|
        end
      end
    end

    describe '#local_executable=' do
      describe 'with the same value,' do
        it 'does not expire the cache' do
          expect(rake).not_to receive(:expire_cache!)
          rake.local_executable = rake.local_executable
        end
      end

      describe 'with a different value,' do
        it 'expires the cache' do
          expect(rake).to receive(:expire_cache!).once
          rake.local_executable = rake.local_executable + ' foo'
        end
      end
    end
  end
end
