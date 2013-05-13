require 'spec_helper'
require 'cape/version'

describe 'Cape::VERSION' do
  specify { expect(Cape::VERSION).to match(/^\d+\.\d+\.\d+/) }
end
