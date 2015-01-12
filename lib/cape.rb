# Contains the implementation of Cape.
module Cape

  autoload :Capistrano,       'cape/capistrano'
  autoload :CoreExt,          'cape/core_ext'
  autoload :DSL,              'cape/dsl'
  autoload :HashList,         'cape/hash_list'
  autoload :Rake,             'cape/rake'
  autoload :RecipeDefinition, 'cape/recipe_definition'
  autoload :Util,             'cape/util'
  autoload :VERSION,          'cape/version'
  autoload :XTerm,            'cape/xterm'

  extend DSL

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
