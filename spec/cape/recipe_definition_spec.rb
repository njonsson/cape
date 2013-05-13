require 'cape/recipe_definition'

describe Cape::RecipeDefinition do
  its(:cd) { should be_nil }

  it 'should have a mutable #cd' do
    subject.cd '/foo/bar'
    expect(subject.cd).to eq('/foo/bar')

    subject.cd lambda { '/foo/bar' }
    expect(subject.cd.call).to eq('/foo/bar')

    subject.cd { '/foo/bar' }
    expect(subject.cd.call).to eq('/foo/bar')
  end

  it 'should complain about a #cd with the wrong arity' do
    expect {
      subject.cd do |foo, bar|
      end
    }.to raise_error(ArgumentError, 'Must have 0 parameters but has 2')
  end

  its(:env) { should == {} }

  it 'should have a mutable #env' do
    subject.env['FOO'] = 'bar'
    expect(subject.env).to eq('FOO' => 'bar')
  end

  its(:options) { should == {} }

  it 'should have mutable #options' do
    subject.options[:some_option] = 'foo'
    expect(subject.options).to eq(:some_option => 'foo')
  end

  its(:rename) { should be_nil }

  it 'should have a mutable #rename' do
    subject.rename do |task_name|
      "#{task_name}_recipe"
    end
    expect(subject.rename.call(:foo)).to eq('foo_recipe')
  end

  it 'should complain about a #rename with the wrong arity' do
    expect {
      subject.rename do |foo, bar|
      end
    }.to raise_error(ArgumentError, 'Must have 1 parameter but has 2')
  end
end
