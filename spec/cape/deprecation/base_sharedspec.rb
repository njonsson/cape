require 'spec_helper'
require 'cape/deprecation/base'

shared_examples_for "a #{Cape::Deprecation::Base.name}" do
  describe '-- without specified attributes --' do
    describe '#stream' do
      specify { expect(subject.stream).to eq($stderr) }
    end
  end

  describe '-- with a different #stream --' do
    before :each do
      subject.stream = different_stream
    end

    let(:different_stream) { StringIO.new }

    describe '#stream' do
      specify { expect(subject.stream).to eq(different_stream) }
    end
  end
end
