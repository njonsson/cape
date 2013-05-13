require 'spec_helper'
require 'cape/xterm'

describe Cape::XTerm do
  describe '.format' do
    it 'should not try to format a nil argument' do
      expect(described_class.format(nil)).to be_nil
    end

    it 'should not try to format a nil argument with a recognized format' do
      expect(described_class.format(nil, :bold)).to be_nil
    end

    specify do
      expect {
        described_class.format nil, :this_does_not_exist
      }.to raise_error(ArgumentError, 'Unrecognized format :this_does_not_exist')
    end

    specify do
      expect {
        described_class.format 'foo', :this_does_not_exist
      }.to raise_error(ArgumentError, 'Unrecognized format :this_does_not_exist')
    end

    described_class::FORMATS.each do |format, code|
      it "should format a String argument with the #{format.inspect} format" do
        expect(described_class.format('foo',
                                      format)).to eq("\e[#{code}mfoo\e[0m")
      end
    end

    it "should format a String argument with the :bold and :foreground_red formats" do
      expect(described_class.format('foo',
                                    :bold,
                                    :foreground_red)).to eq("\e[1;31mfoo\e[0m")
    end
  end

  specify { expect(described_class).not_to respond_to(:this_does_not_exist) }

  specify do
    expect {
      described_class.this_does_not_exist
    }.to raise_error(NoMethodError,
                     "undefined method `this_does_not_exist' for #{described_class.name}:Module")
  end

  described_class::FORMATS.each do |format, code|
    specify { expect(described_class).to respond_to(format) }

    describe ".#{format}" do
      it "should format a String argument with the #{format.inspect} format" do
        expect(described_class.send(format,
                                    'foo')).to eq(described_class.format('foo',
                                                                         format))
      end
    end
  end

  specify { expect(described_class).to respond_to(:bold_and_foreground_red) }

  describe '.bold_and_foreground_red' do
    it "should format a String argument with the :bold and :foreground_red formats" do
      expect(described_class.bold_and_foreground_red('foo')).to eq(described_class.format('foo',
                                                                                          :bold,
                                                                                          :foreground_red))
    end
  end
end
