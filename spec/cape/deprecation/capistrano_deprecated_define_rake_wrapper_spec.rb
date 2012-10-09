require 'spec_helper'
require 'cape/deprecation/capistrano_deprecated_define_rake_wrapper'
require 'cape/deprecation/base_sharedspec'
require 'cape/xterm'

describe Cape::Deprecation::CapistranoDeprecatedDefineRakeWrapper do
  it_should_behave_like "a #{Cape::Deprecation::Base.name}"

  let(:deprecation_preamble) {
    Cape::XTerm.bold_and_foreground_red('*** DEPRECATED:') + ' '
  }

  describe '-- without specified attributes --' do
    its(:formatted_message) {
      should == deprecation_preamble                       +
                Cape::XTerm.bold('`define_rake_wrapper`. ' +
                                 'Use this instead: `define_rake_wrapper`')
    }
  end

  describe '-- with #task' do
    before :each do
      subject.task = {:name => :foo}
    end

    its(:formatted_message) {
      should == deprecation_preamble                                     +
                Cape::XTerm.bold('`define_rake_wrapper {:name=>:foo}`. ' +
                                 'Use this instead: '                    +
                                 '`define_rake_wrapper {:name=>:foo}`')
    }

    describe 'and with #named_arguments' do
      before :each do
        subject.named_arguments = {:bar => :baz}
      end

      its(:formatted_message) {
        should == deprecation_preamble                                                +
                  Cape::XTerm.bold('`'                                                +
                                    'define_rake_wrapper {:name=>:foo}, '             +
                                                         ':bar => :baz'               +
                                   '`. '                                              +
                                   'Use this instead: '                               +
                                   '`'                                                +
                                    'define_rake_wrapper({:name=>:foo}) { |recipes| ' +
                                      'recipes.options[:bar] = :baz '                 +
                                    '}'                                               +
                                   '`')
      }

      describe 'and with #env --' do
        before :each do
          subject.env['QUX'] = 'quux'
        end

        its(:formatted_message) {
          should == deprecation_preamble                                                +
                    Cape::XTerm.bold('`'                                                +
                                      'define_rake_wrapper({:name=>:foo}, '             +
                                                          ':bar => :baz) { |env| '      +
                                        'env["QUX"] = "quux" '                          +
                                      '}'                                               +
                                     '`. '                                              +
                                     'Use this instead: '                               +
                                     '`'                                                +
                                      'define_rake_wrapper({:name=>:foo}) { |recipes| ' +
                                        'recipes.options[:bar] = :baz; '                +
                                        'recipes.env["QUX"] = "quux" '                  +
                                      '}'                                               +
                                     '`')
        }
      end
    end

    describe 'and with #env --' do
      before :each do
        subject.env['BAR'] = 'baz'
      end

      its(:formatted_message) {
        should == deprecation_preamble                                                +
                  Cape::XTerm.bold('`'                                                +
                                    'define_rake_wrapper({:name=>:foo}) { |env| '     +
                                      'env["BAR"] = "baz" '                           +
                                    '}'                                               +
                                   '`. '                                              +
                                   'Use this instead: '                               +
                                   '`'                                                +
                                    'define_rake_wrapper({:name=>:foo}) { |recipes| ' +
                                      'recipes.env["BAR"] = "baz" '                   +
                                    '}'                                               +
                                   '`')
      }
    end
  end

  describe '-- with #named_arguments' do
    before :each do
      subject.named_arguments = {:foo => :bar}
    end

    its(:formatted_message) {
      should == deprecation_preamble                                    +
                Cape::XTerm.bold('`define_rake_wrapper :foo => :bar`. ' +
                                 'Use this instead: '                   +
                                 '`'                                    +
                                  'define_rake_wrapper { |recipes| '    +
                                    'recipes.options[:foo] = :bar '     +
                                  '}'                                   +
                                 '`')
    }

    describe 'and with #env --' do
      before :each do
        subject.env['BAZ'] = 'qux'
      end

      its(:formatted_message) {
        should == deprecation_preamble                                           +
                  Cape::XTerm.bold('`'                                           +
                                    'define_rake_wrapper(:foo => :bar) { |env| ' +
                                      'env["BAZ"] = "qux" '                      +
                                    '}'                                          +
                                   '`. '                                         +
                                   'Use this instead: '                          +
                                   '`'                                           +
                                    'define_rake_wrapper { |recipes| '           +
                                      'recipes.options[:foo] = :bar; '           +
                                      'recipes.env["BAZ"] = "qux" '              +
                                    '}'                                          +
                                   '`')
      }
    end
  end

  describe '-- with #env --' do
    before :each do
      subject.env['FOO'] = 'bar'
    end

    its(:formatted_message) {
      should == deprecation_preamble                                 +
                Cape::XTerm.bold('`'                                 +
                                  'define_rake_wrapper { |env| '     +
                                    'env["FOO"] = "bar" '            +
                                  '}'                                +
                                 '`. '                               +
                                 'Use this instead: '                +
                                 '`'                                 +
                                  'define_rake_wrapper { |recipes| ' +
                                    'recipes.env["FOO"] = "bar" '    +
                                  '}'                                +
                                 '`')
    }
  end
end
