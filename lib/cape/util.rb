module Cape

  # Provides utility functions.
  module Util

    # Conditionally transforms the specified _noun_ into its plural form.
    #
    # @param [String] singular_noun  a singular noun
    # @param [Fixnum] count the quantity of _singular_noun_; optional
    # @return [String] the plural of _singular_noun_, unless _count_ is +1+
    def self.pluralize(singular_noun, count=2)
      return singular_noun if count == 1

      "#{singular_noun}s"
    end

    # Builds a list phrase from the elements of the specified _array_.
    #
    # @param [Array of String] array zero or more nouns
    # @return [String] the elements of _array_, joined with commas and "and", as
    #                  appropriate
    def self.to_list_phrase(array)
      return array.join(' and ') if (array.length <= 2)

      [array[0...-1].join(', '), array[-1]].join ', and '
    end

  end

end
