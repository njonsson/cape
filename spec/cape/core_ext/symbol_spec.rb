require 'spec_helper'
require 'cape/core_ext/symbol'

describe Symbol do
  describe '#<=>' do
    describe 'with a lower symbol' do
      specify { expect(:foo <=> :bar).to eq(1) }
    end

    describe 'with a higher symbol' do
      specify { expect(:baz <=> :qux).to eq(-1) }
    end

    describe 'with itself' do
      specify { expect(:quux <=> :quux).to eq(0) }
    end
  end
end
