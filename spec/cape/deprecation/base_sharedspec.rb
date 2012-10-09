require 'spec_helper'
require 'cape/deprecation/base'

shared_examples_for "a #{Cape::Deprecation::Base.name}" do
  describe '-- without specified attributes --' do
    its(:stream) { should == $stderr }
  end

  describe '-- with a different #stream --' do
    before :each do
      subject.stream = different_stream
    end

    let(:different_stream) { StringIO.new }

    its(:stream) { should == different_stream }
  end
end
