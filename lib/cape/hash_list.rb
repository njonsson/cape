module Cape

  # A HashList is a collection of key-value pairs. It is similar to an Array,
  # except that indexing is done via arbitrary keys of any object type, not an
  # integer index. Hashes enumerate their values in the order that the
  # corresponding keys were inserted.
  #
  # This class exists because in Ruby v1.8.7 and earlier, Hash did not preserve
  # the insertion order of keys.
  #
  # @api private
  class HashList < ::Array

    # Constructs a new HashList using the specified _arguments_.
    #
    # @param [Hash] arguments attribute values
    def initialize(*arguments)
      super Hash[*arguments].to_a
    end

    # Compares a HashList to another object.
    #
    # @param [Object] other another object
    #
    # @return [true]  the HashList has the same number of keys as _other_, and
    #                 each key-value pair is equal (according to Object#==)
    # @return [false] the HashList is not equal to _other_
    def ==(other)
      other.is_a?(::Hash) ? (other == to_hash) : super(other)
    end

    # Retrieves a value from the HashList.
    #
    # @param [Object] key a key
    #
    # @return [Object] the value for _key_
    # @return [nil]    if there is no value for _key_
    def [](key)
      entry = find do |pair|
        Array(pair).first == key
      end
      entry ? Array(entry).last : nil
    end

    # Sets a value in the HashList.
    #
    # @param [Object] key   a key
    # @param [Object] value a value for _key_
    #
    # @return [HashList] the HashList
    def []=(key, value)
      index = find_index do |pair|
        Array(pair).first == key
      end
      if index
        super(index, [key, value])
      else
        self << [key, value]
      end
      self
    end

    # Provides a string representation of the HashList.
    #
    # @return [String] a string representation of the HashList
    def inspect
      entries = collect do |pair|
        Array(pair).collect(&:inspect).join '=>'
      end
      "{#{entries.join ', '}}"
    end

    # Converts the HashList to a Hash.
    #
    # @return [Hash] a hash
    def to_hash
      ::Hash[to_a]
    end

  end

end
