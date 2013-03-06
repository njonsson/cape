::Dir.glob(::File.expand_path('../core_ext/*.rb', __FILE__)) do |f|
  require "cape/core_ext/#{::File.basename f, '.rb'}"
end

module Cape

  # Contains extensions to core types.
  #
  # @api private
  module CoreExt; end

end
