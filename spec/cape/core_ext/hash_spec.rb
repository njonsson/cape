require 'cape/core_ext/hash'

describe Hash do
  describe '#slice' do
    it 'should return the expected Hash' do
      hash = {:foo => 'bar', :baz => 'qux', :quux => 'corge'}
      hash.slice(:baz, :quux).should == {:baz => 'qux', :quux => 'corge'}

      {}.slice(:foo).should == {}
    end
  end
end
