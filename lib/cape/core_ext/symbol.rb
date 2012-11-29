module Cape

  module CoreExt

    # Adds methods missing from Ruby's Symbol core class.
    module Symbol

      # Compares the String representation of the Symbol to that of another.
      #
      # @param [Symbol] other
      #
      # @return  [0] the Symbol is equal to _other_
      # @return [-1] the Symbol is lesser than _other_
      # @return  [1] the Symbol is greater than _other_
      def <=>(other)
        to_s <=> other.to_s
      end

    end

  end

end

unless ::Symbol.instance_methods.collect(&:to_s).include?('<=>')
  ::Symbol.class_eval do
    include Cape::CoreExt::Symbol
  end
end
