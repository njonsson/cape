require 'cape/util'

describe Cape::Util do
  describe '::pluralize' do
    it "should pluralize 'foo' as expected" do
      Cape::Util.pluralize('foo').should == 'foos'
    end

    it "should pluralize 'foo' as expected for a count of 2" do
      Cape::Util.pluralize('foo', 2).should == 'foos'
    end

    it "should not pluralize for a count of 1" do
      Cape::Util.pluralize('foo', 1).should == 'foo'
    end

    it "should pluralize 'foo' as expected for a count of 0" do
      Cape::Util.pluralize('foo', 0).should == 'foos'
    end

    it "should pluralize 'foo' as expected for a count of -1" do
      Cape::Util.pluralize('foo', -1).should == 'foos'
    end
  end

  describe '::to_list_phrase' do
    it 'should make the expected list phrase of an empty array' do
      Cape::Util.to_list_phrase([]).should == ''
    end

    it 'should make the expected list phrase of a 1-element array' do
      Cape::Util.to_list_phrase(%w(foo)).should == 'foo'
    end

    it 'should make the expected list phrase of a 2-element array' do
      Cape::Util.to_list_phrase(%w(foo bar)).should == 'foo and bar'
    end

    it 'should make the expected list phrase of a 3-element array' do
      array = %w(foo bar baz)
      Cape::Util.to_list_phrase(array).should == 'foo, bar, and baz'
    end
  end
end 
