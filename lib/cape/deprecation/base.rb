require 'cape/xterm'

module Cape

  module Deprecation

    # Prints to a stream a message related to deprecated API usage.
    #
    # @abstract
    class Base

      # Sets the value of {#stream}.
      #
      # @param [IO] value a new value for {#stream}
      #
      # @return [IO] _value_
      attr_writer :stream

      # Formats {#message_content} for display.
      #
      # @return [String] the full message
      def formatted_message
        [].tap do |fragments|
          fragments << XTerm.bold_and_foreground_red('*** DEPRECATED:')
          fragments << ' '
          fragments << XTerm.bold(message_content)
        end.join
      end

      # Prepares a message based on deprecated API usage.
      #
      # @raise [NotImplementedError]
      #
      # @abstract
      def message_content
        raise ::NotImplementedError
      end

      # The stream to which deprecation messages are printed. Defaults to
      # $stderr.
      #
      # @return [IO]
      def stream
        @stream ||= $stderr
      end

      # Writes {#formatted_message} to {#stream}.
      #
      # @return [Base] the object
      def write_formatted_message_to_stream
        stream.puts formatted_message
        self
      end

    end

  end

end
