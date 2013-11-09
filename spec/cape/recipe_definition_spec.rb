require 'cape/recipe_definition'

describe Cape::RecipeDefinition do
  subject(:recipe_definition) { recipe_definition_class.new }

  let(:recipe_definition_class) { described_class }

  describe '#cd' do
    specify { expect(recipe_definition.cd).to be_nil }

    it 'is mutable' do
      recipe_definition.cd '/foo/bar'
      expect(recipe_definition.cd).to eq('/foo/bar')

      recipe_definition.cd lambda { '/foo/bar' }
      expect(recipe_definition.cd.call).to eq('/foo/bar')

      recipe_definition.cd { '/foo/bar' }
      expect(recipe_definition.cd.call).to eq('/foo/bar')
    end

    it 'complains about wrong arity' do
      expect {
        recipe_definition.cd do |foo, bar|
        end
      }.to raise_error(ArgumentError, 'Must have 0 parameters but has 2')
    end
  end

  describe '#env' do
    specify { expect(recipe_definition.env).to eq({}) }

    it 'is mutable' do
      recipe_definition.env['FOO'] = 'bar'
      expect(recipe_definition.env).to eq('FOO' => 'bar')
    end
  end

  describe '#options' do
    specify { expect(recipe_definition.options).to eq({}) }

    it 'is mutable' do
      recipe_definition.options[:some_option] = 'foo'
      expect(recipe_definition.options).to eq(:some_option => 'foo')
    end
  end

  describe '#rename' do
    specify { expect(recipe_definition.rename).to be_nil }

    it 'is mutable' do
      recipe_definition.rename do |task_name|
        "#{task_name}_recipe"
      end
      expect(recipe_definition.rename.call(:foo)).to eq('foo_recipe')
    end

    it 'complains about wrong arity' do
      expect {
        recipe_definition.rename do |foo, bar|
        end
      }.to raise_error(ArgumentError, 'Must have 1 parameter but has 2')
    end
  end
end
