require 'cape/recipe_definition'

module Cape

  # Implements {RecipeDefinition} with deprecated methods.
  #
  # @api private
  class RecipeDefinitionDeprecated < RecipeDefinition

    # The object in which deprecated API usage is recorded.
    #
    # @return [Deprecation::Base]
    attr_reader :deprecation

    # Constructs a new RecipeDefinitionDeprecated with the specified
    # _deprecation_.
    #
    # @param [Deprecation::Base] deprecation the value of {#deprecation}
    def initialize(deprecation)
      @deprecation = deprecation
    end

    # Sets a remote environment variable.
    #
    # @param [String] name  the name of a remote environment variable
    # @param [String] value a value for the remote environment variable
    #
    # @return [RecipeDefinitionDeprecated] the object
    #
    # @deprecated Use {RecipeDefinition#env} instead.
    #
    # @api public
    def []=(name, value)
      env[name]             = value
      deprecation.env[name] = value
      self
    end

  end

end
