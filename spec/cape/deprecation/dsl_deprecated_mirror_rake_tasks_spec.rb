require 'spec_helper'
require 'cape/deprecation/dsl_deprecated_mirror_rake_tasks'
require 'cape/deprecation/base_sharedspec'
require 'cape/xterm'

describe Cape::Deprecation::DSLDeprecatedMirrorRakeTasks do
  subject(:dsl_deprecated_mirror_rake_tasks) {
    dsl_deprecated_mirror_rake_tasks_class.new
  }

  let(:dsl_deprecated_mirror_rake_tasks_class) { described_class }

  it_behaves_like "a #{Cape::Deprecation::Base.name}"

  let(:deprecation_preamble) {
    Cape::XTerm.bold_and_foreground_red('*** DEPRECATED:') + ' '
  }

  describe '-- without specified attributes --' do
    describe '#formatted_message' do
      specify {
        expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                     +
                                                                         Cape::XTerm.bold('`mirror_rake_tasks`. ' +
                                                                                          'Use this instead: `mirror_rake_tasks`'))
      }
    end
  end

  describe '-- with #task_expression' do
    before :each do
      dsl_deprecated_mirror_rake_tasks.task_expression = :foo
    end

    describe '#formatted_message' do
      specify {
        expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                          +
                                                                         Cape::XTerm.bold('`mirror_rake_tasks :foo`. ' +
                                                                                          'Use this instead: `mirror_rake_tasks :foo`'))
      }
    end

    describe 'and with #options' do
      before :each do
        dsl_deprecated_mirror_rake_tasks.options = {:bar => :baz}
      end

      describe '#formatted_message' do
        specify {
          expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                          +
                                                                           Cape::XTerm.bold('`mirror_rake_tasks :foo, :bar => :baz`. ' +
                                                                                            'Use this instead: '                       +
                                                                                            '`'                                        +
                                                                                             'mirror_rake_tasks(:foo) { |recipes| '    +
                                                                                               'recipes.options[:bar] = :baz '         +
                                                                                             '}'                                       +
                                                                                            '`'))
        }
      end

      describe 'and with #env --' do
        before :each do
          dsl_deprecated_mirror_rake_tasks.env['QUX'] = 'quux'
        end

        describe '#formatted_message' do
          specify {
            expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                          +
                                                                             Cape::XTerm.bold('`'                                         +
                                                                                               'mirror_rake_tasks(:foo, '                 +
                                                                                                                 ':bar => :baz) { |env| ' +
                                                                                                 'env["QUX"] = "quux" '                   +
                                                                                               '}'                                        +
                                                                                              '`. '                                       +
                                                                                              'Use this instead: '                        +
                                                                                              '`'                                         +
                                                                                               'mirror_rake_tasks(:foo) { |recipes| '     +
                                                                                                 'recipes.options[:bar] = :baz; '         +
                                                                                                 'recipes.env["QUX"] = "quux" '           +
                                                                                               '}'                                        +
                                                                                              '`'))
          }
        end
      end
    end

    describe 'and with #env --' do
      before :each do
        dsl_deprecated_mirror_rake_tasks.env['BAR'] = 'baz'
      end

      describe '#formatted_message' do
        specify {
          expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                          +
                                                                           Cape::XTerm.bold('`'                                     +
                                                                                             'mirror_rake_tasks(:foo) { |env| '     +
                                                                                               'env["BAR"] = "baz" '                +
                                                                                             '}'                                    +
                                                                                            '`. '                                   +
                                                                                            'Use this instead: '                    +
                                                                                            '`'                                     +
                                                                                             'mirror_rake_tasks(:foo) { |recipes| ' +
                                                                                               'recipes.env["BAR"] = "baz" '        +
                                                                                             '}'                                    +
                                                                                            '`'))
        }
      end
    end
  end

  describe '-- with #options' do
    before :each do
      dsl_deprecated_mirror_rake_tasks.options = {:foo => :bar}
    end

    describe '#formatted_message' do
      specify {
        expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                          +
                                                                         Cape::XTerm.bold('`mirror_rake_tasks :foo => :bar`. ' +
                                                                                          'Use this instead: '                 +
                                                                                          '`'                                  +
                                                                                           'mirror_rake_tasks { |recipes| '    +
                                                                                             'recipes.options[:foo] = :bar '   +
                                                                                           '}'                                 +
                                                                                          '`'))
      }
    end

    describe 'and with #env --' do
      before :each do
        dsl_deprecated_mirror_rake_tasks.env['BAZ'] = 'qux'
      end

      describe '#formatted_message' do
        specify {
          expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                          +
                                                                           Cape::XTerm.bold('`'                                         +
                                                                                             'mirror_rake_tasks(:foo => :bar) { |env| ' +
                                                                                               'env["BAZ"] = "qux" '                    +
                                                                                             '}'                                        +
                                                                                            '`. '                                       +
                                                                                            'Use this instead: '                        +
                                                                                            '`'                                         +
                                                                                             'mirror_rake_tasks { |recipes| '           +
                                                                                               'recipes.options[:foo] = :bar; '         +
                                                                                               'recipes.env["BAZ"] = "qux" '            +
                                                                                             '}'                                        +
                                                                                            '`'))
        }
      end
    end
  end

  describe '-- with #env --' do
    before :each do
      dsl_deprecated_mirror_rake_tasks.env['FOO'] = 'bar'
    end

    describe '#formatted_message' do
      specify {
        expect(dsl_deprecated_mirror_rake_tasks.formatted_message).to eq(deprecation_preamble                          +
                                                                         Cape::XTerm.bold('`'                               +
                                                                                           'mirror_rake_tasks { |env| '     +
                                                                                             'env["FOO"] = "bar" '          +
                                                                                           '}'                              +
                                                                                          '`. '                             +
                                                                                          'Use this instead: '              +
                                                                                          '`'                               +
                                                                                           'mirror_rake_tasks { |recipes| ' +
                                                                                             'recipes.env["FOO"] = "bar" '  +
                                                                                           '}'                              +
                                                                                          '`'))
      }
    end
  end
end
