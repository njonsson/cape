require 'spec_helper'
require 'cape'
require 'cape/dsl'

describe Cape do
  let(:cape_module) { described_class }

  Cape::DSL.public_instance_methods.each do |m|
    specify { expect(cape_module).to respond_to(m) }
  end
end

describe '#Cape' do
  it 'yields the Cape module if given a unary block' do
    yielded = nil
    Cape do |c|
      yielded = c
    end
    expect(yielded).to eq(Cape)
  end

  it 'accepts a nullary block' do
    Cape do
    end
  end

  it 'expires the Rake tasks cache when leaving the block' do
    Cape do
      expect(rake).to receive(:expire_cache!).once
    end
  end
end
