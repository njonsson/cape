Dir.glob( File.expand_path( 'cape/*.rb', File.dirname( __FILE__ ))) do |f|
  require "cape/#{File.basename f, '.rb'}"
end

# Contains the implementation of Cape.
module Cape

  extend DSL

end

# The method used to group Cape statements in a block.
def Cape(&block)
  Cape.module_eval do
    @outer_self = block.binding.eval('self', __FILE__, __LINE__)
    if 0 < block.arity
      block.call self
    else
      module_eval(&block)
    end
  end
end
