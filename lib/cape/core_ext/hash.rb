module Cape

  module CoreExt

    # Adds methods missing from Ruby's Hash core class.
    module Hash

      # Returns a copy of the Hash containing values only for the specified
      # _keys_.
      #
      # @param [Array] keys zero or more hash keys
      #
      # @return [Hash] a subset of the Hash
      def slice(*keys)
        ::Hash[select { |key, value| keys.include? key }]
      end

    end

  end

end

unless ::Hash.instance_methods.collect(&:to_s).include?('slice')
  ::Hash.class_eval do
    include Cape::CoreExt::Hash
  end
end
