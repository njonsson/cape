module Cape

  # Contains implementations of deprecation stream printers.
  #
  # @api private
  module Deprecation

    autoload :Base, 'cape/deprecation/base'
    autoload :CapistranoDeprecatedDefineRakeWrapper ,
             'cape/deprecation/capistrano_deprecated_define_rake_wrapper'
    autoload :DSLDeprecatedMirrorRakeTasks ,
             'cape/deprecation/dsl_deprecated_mirror_rake_tasks'

  end

end
