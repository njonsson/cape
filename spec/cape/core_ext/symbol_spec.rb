require 'cape/core_ext/symbol'

describe Symbol do
  it 'should compare as expected to another Symbol' do
    (:foo <=> :bar).should == 1
  end
end
