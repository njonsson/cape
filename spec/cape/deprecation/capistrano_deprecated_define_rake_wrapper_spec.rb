require 'spec_helper'
require 'cape/deprecation/capistrano_deprecated_define_rake_wrapper'
require 'cape/deprecation/base_sharedspec'
require 'cape/xterm'

describe Cape::Deprecation::CapistranoDeprecatedDefineRakeWrapper do
  subject(:capistrano_deprecated_define_rake_wrapper) {
    capistrano_deprecated_define_rake_wrapper_class.new
  }

  let(:capistrano_deprecated_define_rake_wrapper_class) { described_class }

  it_behaves_like "a #{Cape::Deprecation::Base.name}"

  let(:deprecation_preamble) {
    Cape::XTerm.bold_and_foreground_red('*** DEPRECATED:') + ' '
  }

  describe '-- without specified attributes --' do
    describe '#formatted_message' do
      specify {
        expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                       +
                                                                                  Cape::XTerm.bold('`define_rake_wrapper`. ' +
                                                                                                   'Use this instead: `define_rake_wrapper`'))
      }
    end
  end

  describe '-- with #task' do
    before :each do
      capistrano_deprecated_define_rake_wrapper.task = {:name => :foo}
    end

    describe '#formatted_message' do
      specify {
        expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                                     +
                                                                                  Cape::XTerm.bold('`define_rake_wrapper {:name=>:foo}`. ' +
                                                                                                   'Use this instead: '                    +
                                                                                                   '`define_rake_wrapper {:name=>:foo}`'))
      }
    end

    describe 'and with #named_arguments' do
      before :each do
        capistrano_deprecated_define_rake_wrapper.named_arguments = {:bar => :baz}
      end

      describe '#formatted_message' do
        specify {
          expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                                                +
                                                                                    Cape::XTerm.bold('`'                                                +
                                                                                                      'define_rake_wrapper {:name=>:foo}, '             +
                                                                                                                           ':bar => :baz'               +
                                                                                                     '`. '                                              +
                                                                                                     'Use this instead: '                               +
                                                                                                     '`'                                                +
                                                                                                      'define_rake_wrapper({:name=>:foo}) { |recipes| ' +
                                                                                                        'recipes.options[:bar] = :baz '                 +
                                                                                                      '}'                                               +
                                                                                                     '`'))
        }
      end

      describe 'and with #env --' do
        before :each do
          capistrano_deprecated_define_rake_wrapper.env['QUX'] = 'quux'
        end

        describe '#formatted_message' do
          specify {
            expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                                                +
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
                                                                                                       '`'))
          }
        end
      end
    end

    describe 'and with #env --' do
      before :each do
        capistrano_deprecated_define_rake_wrapper.env['BAR'] = 'baz'
      end

      describe '#formatted_message' do
        specify {
          expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                                                +
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
                                                                                                     '`'))
        }
      end
    end
  end

  describe '-- with #named_arguments' do
    before :each do
      capistrano_deprecated_define_rake_wrapper.named_arguments = {:foo => :bar}
    end

    describe '#formatted_message' do
      specify {
        expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                                                +
                                                                                  Cape::XTerm.bold('`define_rake_wrapper :foo => :bar`. ' +
                                                                                                   'Use this instead: '                   +
                                                                                                   '`'                                    +
                                                                                                    'define_rake_wrapper { |recipes| '    +
                                                                                                      'recipes.options[:foo] = :bar '     +
                                                                                                    '}'                                   +
                                                                                                   '`'))
      }
    end

    describe 'and with #env --' do
      before :each do
        capistrano_deprecated_define_rake_wrapper.env['BAZ'] = 'qux'
      end

      describe '#formatted_message' do
        specify {
          expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                                                +
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
                                                                                                     '`'))
        }
      end
    end
  end

  describe '-- with #env --' do
    before :each do
      capistrano_deprecated_define_rake_wrapper.env['FOO'] = 'bar'
    end

    describe '#formatted_message' do
      specify {
        expect(capistrano_deprecated_define_rake_wrapper.formatted_message).to eq(deprecation_preamble                                                +
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
                                                                                                   '`'))
      }
    end
  end
end
