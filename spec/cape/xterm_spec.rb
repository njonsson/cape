require 'spec_helper'
require 'cape/xterm'

describe Cape::XTerm do
  let(:xterm_module) { described_class }

  describe '.format' do
    it 'does not try to format a nil argument' do
      expect(xterm_module.format(nil)).to be_nil
    end

    it 'does not try to format a nil argument with a recognized format' do
      expect(xterm_module.format(nil, :bold)).to be_nil
    end

    specify do
      expect {
        xterm_module.format nil, :this_does_not_exist
      }.to raise_error(ArgumentError, 'Unrecognized format :this_does_not_exist')
    end

    specify do
      expect {
        xterm_module.format 'foo', :this_does_not_exist
      }.to raise_error(ArgumentError, 'Unrecognized format :this_does_not_exist')
    end

    described_class::FORMATS.each do |format, code|
      it "formats a String argument with the #{format.inspect} format" do
        expect(xterm_module.format('foo',
                                   format)).to eq("\e[#{code}mfoo\e[0m")
      end
    end

    it "formats a String argument with the :bold and :foreground_red formats" do
      expect(xterm_module.format('foo',
                                 :bold,
                                 :foreground_red)).to eq("\e[1;31mfoo\e[0m")
    end
  end

  specify { expect(xterm_module).not_to respond_to(:this_does_not_exist) }

  specify do
    expect {
      xterm_module.this_does_not_exist
    }.to raise_error(NoMethodError,
                     "undefined method `this_does_not_exist' for #{xterm_module.name}:Module")
  end

  described_class::FORMATS.each do |format, code|
    specify { expect(xterm_module).to respond_to(format) }

    describe ".#{format}" do
      it "formats a String argument with the #{format.inspect} format" do
        expect(xterm_module.send(format,
                                 'foo')).to eq(xterm_module.format('foo',
                                                                   format))
      end
    end
  end

  specify { expect(xterm_module).to respond_to(:bold_and_foreground_red) }

  describe '.bold_and_foreground_red' do
    it "formats a String argument with the :bold and :foreground_red formats" do
      expect(xterm_module.bold_and_foreground_red('foo')).to eq(xterm_module.format('foo',
                                                                                    :bold,
                                                                                    :foreground_red))
    end
  end
end
