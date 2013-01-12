require 'spec_helper'
require 'cape/version'

describe 'Cape::VERSION' do
  specify { Cape::VERSION.should =~ /^\d+\.\d+\.\d+/ }
end
