require 'spec_helper'
require 'cape/deprecation/dsl_deprecated_mirror_rake_tasks'
require 'cape/deprecation/base_sharedspec'
require 'cape/xterm'

describe Cape::Deprecation::DSLDeprecatedMirrorRakeTasks do
  it_should_behave_like "a #{Cape::Deprecation::Base.name}"

  let(:deprecation_preamble) {
    Cape::XTerm.bold_and_foreground_red('*** DEPRECATED:') + ' '
  }

  describe '-- without specified attributes --' do
    its(:formatted_message) {
      should == deprecation_preamble                     +
                Cape::XTerm.bold('`mirror_rake_tasks`. ' +
                                 'Use this instead: `mirror_rake_tasks`')
    }
  end

  describe '-- with #task_expression' do
    before :each do
      subject.task_expression = :foo
    end

    its(:formatted_message) {
      should == deprecation_preamble                          +
                Cape::XTerm.bold('`mirror_rake_tasks :foo`. ' +
                                 'Use this instead: `mirror_rake_tasks :foo`')
    }

    describe 'and with #options' do
      before :each do
        subject.options = {:bar => :baz}
      end

      its(:formatted_message) {
        should == deprecation_preamble                                        +
                  Cape::XTerm.bold('`mirror_rake_tasks :foo, :bar => :baz`. ' +
                                   'Use this instead: '                       +
                                   '`'                                        +
                                    'mirror_rake_tasks(:foo) { |recipes| '    +
                                      'recipes.options[:bar] = :baz '         +
                                    '}'                                       +
                                   '`')
      }

      describe 'and with #env --' do
        before :each do
          subject.env['QUX'] = 'quux'
        end

        its(:formatted_message) {
          should == deprecation_preamble                                         +
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
                                     '`')
        }
      end
    end

    describe 'and with #env --' do
      before :each do
        subject.env['BAR'] = 'baz'
      end

      its(:formatted_message) {
        should == deprecation_preamble                                     +
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
                                   '`')
      }
    end
  end

  describe '-- with #options' do
    before :each do
      subject.options = {:foo => :bar}
    end

    its(:formatted_message) {
      should == deprecation_preamble                                  +
                Cape::XTerm.bold('`mirror_rake_tasks :foo => :bar`. ' +
                                 'Use this instead: '                 +
                                 '`'                                  +
                                  'mirror_rake_tasks { |recipes| '    +
                                    'recipes.options[:foo] = :bar '   +
                                  '}'                                 +
                                 '`')
    }

    describe 'and with #env --' do
      before :each do
        subject.env['BAZ'] = 'qux'
      end

      its(:formatted_message) {
        should == deprecation_preamble                                         +
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
                                   '`')
      }
    end
  end

  describe '-- with #env --' do
    before :each do
      subject.env['FOO'] = 'bar'
    end

    its(:formatted_message) {
      should == deprecation_preamble                               +
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
                                 '`')
    }
  end
end
