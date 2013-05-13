require 'spec_helper'
require 'cape/core_ext/symbol'

describe Symbol do
  it '-- when sent #<=> with a lower symbol -- should return 1' do
    expect(:foo <=> :bar).to eq(1)
  end

  it '-- when sent #<=> with a higher symbol -- should return -1' do
    expect(:baz <=> :qux).to eq(-1)
  end

  it '-- when sent #<=> with itself -- should return 0' do
    expect(:quux <=> :quux).to eq(0)
  end
end
