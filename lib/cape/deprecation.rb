::Dir.glob(::File.expand_path('../deprecation/*.rb', __FILE__)) do |f|
  require "cape/deprecation/#{::File.basename f, '.rb'}"
end

module Cape

  # Contains implementations of deprecation stream printers.
  #
  # @api private
  module Deprecation; end

end
