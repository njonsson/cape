require 'spec_helper'
require 'cape/capistrano'
require 'cape/rake'

describe Cape::Capistrano do
  subject(:capistrano) { capistrano_class.new }

  let(:capistrano_class) { described_class }

  describe 'without specified attributes' do
    describe '#rake' do
      specify { expect(capistrano.rake).to eq(Cape::Rake.new) }
    end
  end

  describe 'with specified attributes' do
    subject(:capistrano) {
      capistrano_class.new :rake => 'the specified value of #rake'
    }

    describe '#rake' do
      specify { expect(capistrano.rake).to eq('the specified value of #rake') }
    end
  end
end
