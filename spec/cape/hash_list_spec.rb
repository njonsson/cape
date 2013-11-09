require 'spec_helper'
require 'cape/hash_list'

describe Cape::HashList do
  subject(:hash_list) { hash_list_class.new }

  let(:hash_list_class) { described_class }

  describe 'that is empty' do
    specify { expect(hash_list).to be_empty }

    describe '#inspect' do
      specify { expect(hash_list.inspect).to eq('{}') }
    end

    describe '#to_a' do
      specify { expect(hash_list.to_a).to eq([]) }
    end

    describe '#to_hash' do
      specify { expect(hash_list.to_hash).to eq({}) }
    end

    describe 'when values are added out of order' do
      before :each do
        hash_list['foo'] = 'xxx'
        hash_list['foo'] = 'bar'
        hash_list['baz'] = 'qux'
      end

      specify { expect(hash_list).to eq({'foo' => 'bar', 'baz' => 'qux'}) }

      describe '#inspect' do
        specify {
          expect(hash_list.inspect).to eq('{"foo"=>"bar", "baz"=>"qux"}')
        }
      end

      describe '#to_a' do
        specify { expect(hash_list.to_a).to eq([%w(foo bar), %w(baz qux)]) }
      end

      describe '#to_hash' do
        specify {
          expect(hash_list.to_hash).to eq({'foo' => 'bar', 'baz' => 'qux'})
        }
      end
    end
  end

  describe 'that has values out of order' do
    subject(:hash_list) { hash_list_class.new 'foo' => 'bar', 'baz' => 'qux' }

    specify { expect(hash_list).to eq({'foo' => 'bar', 'baz' => 'qux'}) }

    it 'indexes the values as expected' do
      expect(hash_list['foo']).to eq('bar')
      expect(hash_list['baz']).to eq('qux')
      expect(hash_list['not-found']).to be_nil
    end

    describe '#clear' do
      before :each do
        hash_list.clear
      end

      specify { expect(hash_list).to be_empty }
    end
  end
end
