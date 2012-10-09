::Dir.glob(::File.expand_path('../cape/*.rb', __FILE__)) do |f|
  require "cape/#{::File.basename f, '.rb'}"
end

# Contains the implementation of Cape.
module Cape

  extend DSL
  extend DSLDeprecated

end

# The method used to group Cape statements.
#
# @param [Proc] block Cape and Capistrano statements
#
# @return [Cape] the Cape module
#
# @yield [cape] a block containing Cape statements
# @yieldparam [Cape::DSL] cape the Cape DSL; optional
#
# @example Basic Cape usage
#   # config/deploy.rb
#
#   require 'cape'
#
#   Cape do
#     mirror_rake_tasks
#   end
#
# @example Combining Cape statements with Capistrano statements
#   # config/deploy.rb
#
#   require 'cape'
#
#   namespace :rake_tasks do
#     # Use an argument with the Cape block, if you want to or need to.
#     Cape do |cape|
#       cape.mirror_rake_tasks
#     end
#   end
def Cape(&block)
  Cape.module_eval do
    @outer_self = block.binding.eval('self', __FILE__, __LINE__)
    begin
      if 0 < block.arity
        block.call self
      else
        module_eval(&block)
      end
    ensure
      rake.expire_cache!
    end
  end
  Cape
end
