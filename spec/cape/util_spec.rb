require 'spec_helper'
require 'cape/util'

describe Cape::Util do
  describe '.pluralize' do
    it "transforms 'foo' as expected" do
      expect(Cape::Util.pluralize('foo')).to eq('foos')
    end

    it "transforms 'foo' as expected for a count of 2" do
      expect(Cape::Util.pluralize('foo', 2)).to eq('foos')
    end

    it "does not transform 'foo' for a count of 1" do
      expect(Cape::Util.pluralize('foo', 1)).to eq('foo')
    end

    it "transforms 'foo' as expected for a count of 0" do
      expect(Cape::Util.pluralize('foo', 0)).to eq('foos')
    end

    it "transforms 'foo' as expected for a count of -1" do
      expect(Cape::Util.pluralize('foo', -1)).to eq('foos')
    end
  end

  describe '.to_list_phrase' do
    it 'makes the expected phrase of an empty array' do
      expect(Cape::Util.to_list_phrase([])).to eq('')
    end

    it 'makes the expected phrase of a 1-element array' do
      expect(Cape::Util.to_list_phrase(%w(foo))).to eq('foo')
    end

    it 'makes the expected phrase of a 2-element array' do
      expect(Cape::Util.to_list_phrase(%w(foo bar))).to eq('foo and bar')
    end

    it 'makes the expected phrase of a 3-element array' do
      array = %w(foo bar baz)
      expect(Cape::Util.to_list_phrase(array)).to eq('foo, bar, and baz')
    end
  end
end 
