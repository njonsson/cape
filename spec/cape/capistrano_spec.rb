require 'spec_helper'
require 'cape/capistrano'
require 'cape/rake'

describe Cape::Capistrano do
  describe 'without specified attributes' do
    its(:rake) { should == Cape::Rake.new }
  end

  describe 'with specified attributes' do
    subject { described_class.new :rake => 'the specified value of #rake' }

    its(:rake) { should == 'the specified value of #rake' }
  end
end
