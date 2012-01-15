require 'cape/capistrano'
require 'cape/rake'

describe Cape::Capistrano do
  describe 'without specified attributes' do
    its(:rake) { should == Cape::Rake.new }
  end

  describe 'with specified attributes' do
    subject {
      described_class.new :rake => 'I see you have the machine that goes "Bing!"'
    }

    its(:rake) { should == 'I see you have the machine that goes "Bing!"' }
  end
end
