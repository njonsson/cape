require 'spec_helper'
require 'cape/core_ext/symbol'

describe Symbol do
  it '-- when sent #<=> with a lower symbol -- should return 1' do
    (:foo <=> :bar).should == 1
  end

  it '-- when sent #<=> with a higher symbol -- should return -1' do
    (:baz <=> :qux).should == -1
  end

  it '-- when sent #<=> with itself -- should return 0' do
    (:quux <=> :quux).should == 0
  end
end
