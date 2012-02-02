require 'cape'
require 'cape/dsl'

describe Cape do
  Cape::DSL.instance_methods.each do |m|
    it { should respond_to(m) }
  end
end

describe '#Cape' do
  it 'should yield the Cape module if given a unary block' do
    yielded = nil
    Cape do |c|
      yielded = c
    end
    yielded.should == Cape
  end

  it 'should accept a nullary block' do
    Cape do
    end
  end

  it 'should expire the Rake tasks cache when leaving the block' do
    Cape do
      rake.should_receive(:expire_cache!).once
    end
  end
end
