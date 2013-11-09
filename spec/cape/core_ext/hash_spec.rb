require 'spec_helper'
require 'cape/core_ext/hash'

describe Hash do
  subject(:hash) { {:foo => 'bar', :baz => 'qux', :quux => 'corge'} }

  describe '#slice with keys that are present and those that are not' do
    it 'returns the expected subset hash' do
      expect(hash.slice(:baz, :fizzle, :quux)).to eq(:baz => 'qux',
                                                     :quux => 'corge')
    end
  end
end
