module Cape

  module CoreExt

    # Contains extensions to the Symbol core class.
    module Symbol

      # Returns +0+ if the Symbol is equal to _other_, +-1+ if it is
      # alphabetically lesser than _other_, and +1+ if it is alphabetically
      # greater than _other_.
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
