module Cape

  module CoreExt

    # Contains extensions to the Hash core class.
    module Hash

      # Returns a copy of the Hash containing values only for the specified
      # _keys_.
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
