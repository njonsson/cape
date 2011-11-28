require 'rspec'
require 'cape/version'

describe Cape::VERSION do
  it { should =~ /^\d+\.\d+\.\d+/ }
end
