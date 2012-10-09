require 'spec_helper'
require 'cape/xterm'

describe Cape::XTerm do
  describe '.format' do
    it 'should not try to format a nil argument' do
      described_class.format(nil).should be_nil
    end

    it 'should not try to format a nil argument with a recognized format' do
      described_class.format(nil, :bold).should be_nil
    end

    it 'should complain about an unrecognized format' do
      expect {
        described_class.format nil, :this_does_not_exist
      }.to raise_error(ArgumentError, 'Unrecognized format :this_does_not_exist')
      expect {
        described_class.format 'foo', :this_does_not_exist
      }.to raise_error(ArgumentError, 'Unrecognized format :this_does_not_exist')
    end

    described_class::FORMATS.each do |format, code|
      it "should format a String argument with the #{format.inspect} format" do
        described_class.format('foo', format).should == "\e[#{code}mfoo\e[0m"
      end
    end

    it "should format a String argument with the :bold and :foreground_red formats" do
      described_class.format('foo',
                             :bold,
                             :foreground_red).should == "\e[1;31mfoo\e[0m"
    end
  end

  it 'should not respond to :this_does_not_exist' do
    described_class.should_not respond_to(:this_does_not_exist)
  end

  it '.this_does_not_exist should complain' do
    expect {
      described_class.this_does_not_exist
    }.to raise_error(NoMethodError,
                     "undefined method `this_does_not_exist' for #{described_class.name}:Module")
  end

  described_class::FORMATS.each do |format, code|
    it "should respond to .#{format.inspect}" do
      described_class.should respond_to(format)
    end

    describe ".#{format}" do
      it "should format a String argument with the #{format.inspect} format" do
        described_class.send(format,
                             'foo').should == described_class.format('foo',
                                                                     format)
      end
    end
  end

  it 'should respond to .bold_and_foreground_red' do
    described_class.should respond_to(:bold_and_foreground_red)
  end

  describe '.bold_and_foreground_red' do
    it "should format a String argument with the :bold and :foreground_red formats" do
      described_class.bold_and_foreground_red('foo').should == described_class.format('foo',
                                                                                      :bold,
                                                                                      :foreground_red)
    end
  end
end
