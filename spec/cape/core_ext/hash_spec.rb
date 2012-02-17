require 'cape/core_ext/hash'

describe Hash do
  subject { {:foo => 'bar', :baz => 'qux', :quux => 'corge'} }

  describe '-- when sent #slice with keys that are present and those that are not --' do
    it 'should return the expected subset hash' do
      subject.slice(:baz, :fizzle, :quux).should == {:baz => 'qux',
                                                     :quux => 'corge'}
    end
  end
end
