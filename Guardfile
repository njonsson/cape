guard 'rspec', :cli => '--color', :version => 2 do
  # Run the corresponding spec (or all specs) when code changes.
  watch( %r{^lib/(.+)\.rb$} ) do |match|
    corresponding_spec = "spec/#{match[1]}_spec.rb"
    if File.file?( File.expand_path( "../#{corresponding_spec}", __FILE__ ))
      corresponding_spec
    else
      'spec'
    end
  end

  # Run a spec when it changes.
  watch %r{^spec/.+_spec\.rb$}

  # Run all specs when the bundle changes.
  watch( 'Gemfile.lock' ) { 'spec' }
end
