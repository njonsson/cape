module Cape

  # Provides utility methods for String objects.
  module Strings

    extend self

    # Returns the English plural form of _noun_, unless _count_ is +1+. The
    # _count_ argument is optional, and defaults to +2+.
    def pluralize(noun, count=2)
      return noun if count == 1

      "#{noun}s"
    end

    # Builds an English list phrase from the elements of _array_.
    def to_list_phrase(array)
      return array.join(' and ') if (array.length <= 2)

      [array[0...-1].join(', '), array[-1]].join ', and '
    end

  end

end
