module Cape

  # Formats output for an xterm console.
  #
  # Convenience class methods are made available dynamically that permit multiple
  # formats to be applied.
  #
  # @example Apply bold and red-foreground formatting to a string
  #   Cape::XTerm.bold_and_foreground_red 'foo'
  #
  # @api private
  module XTerm

    # The xterm formatting codes.
    FORMATS = {:bold               =>  '1',
               :underlined         =>  '4',
               :blinking           =>  '5',
               :inverse            =>  '7',
               :foreground_black   => '30',
               :foreground_red     => '31',
               :foreground_green   => '32',
               :foreground_yellow  => '33',
               :foreground_blue    => '34',
               :foreground_magenta => '35',
               :foreground_cyan    => '36',
               :foreground_gray    => '37',
               :foreground_default => '39',
               :background_black   => '40',
               :background_red     => '41',
               :background_green   => '42',
               :background_yellow  => '43',
               :background_blue    => '44',
               :background_magenta => '45',
               :background_cyan    => '46',
               :background_gray    => '47',
               :background_default => '49'}

    # @!method bold(string)
    #   Formats the specified _string_ in bold type.
    #
    #   @param [String] string the string to format in bold type
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method underlined(string)
    #   Formats the specified _string_ in underlined type.
    #
    #   @param [String] string the string to underline
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method blinking(string)
    #   Formats the specified _string_ in blinking type.
    #
    #   @param [String] string the string to blink
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method inverse(string)
    #   Formats the specified _string_ in inverse colors.
    #
    #   @param [String] string the string whose colors are to be inverted
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_black(string)
    #   Formats the specified _string_ in black.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_red(string)
    #   Formats the specified _string_ in red.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_green(string)
    #   Formats the specified _string_ in green.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_yellow(string)
    #   Formats the specified _string_ in yellow.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_blue(string)
    #   Formats the specified _string_ in blue.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_magenta(string)
    #   Formats the specified _string_ in magenta.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_cyan(string)
    #   Formats the specified _string_ in cyan.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_gray(string)
    #   Formats the specified _string_ in gray.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method foreground_default(string)
    #   Formats the specified _string_ in the default foreground color.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_black(string)
    #   Formats the specified _string_ with a black background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_red(string)
    #   Formats the specified _string_ with a red background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_green(string)
    #   Formats the specified _string_ with a green background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_yellow(string)
    #   Formats the specified _string_ with a yellow background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_blue(string)
    #   Formats the specified _string_ with a blue background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_magenta(string)
    #   Formats the specified _string_ with a magenta background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_cyan(string)
    #   Formats the specified _string_ with a cyan background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_gray(string)
    #   Formats the specified _string_ with a gray background.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # @!method background_default(string)
    #   Formats the specified _string_ in the default background color.
    #
    #   @param [String] string the string to color
    #
    #   @return [String] the formatted _string_
    #
    #   @!scope class
    #
    #   @api private

    # Applies the specified _formats_ to _string_.
    #
    # @param [String]          string  the string to format
    # @param [Array of Symbol] formats the formats to apply
    #
    # @return [String] the formatted _string_
    def self.format(string, *formats)
      formatting_codes = formats.collect do |f|
        unless FORMATS.key?(f)
          raise ::ArgumentError, "Unrecognized format #{f.inspect}"
        end

        FORMATS[f]
      end

      return string if formatting_codes.empty? || string.nil?

      "\e[#{formatting_codes.join ';'}m#{string}\e[0m"
    end

  private

    def self.method_missing(method, *arguments, &block)
      unless respond_to_missing?(method, false)
        return super(method, *arguments, &block)
      end

      formats = method.to_s.split('_and_').collect(&:to_sym)
      format(*(arguments + formats))
    end

    def self.respond_to_missing?(method, include_private)
      formats = method.to_s.split('_and_').collect(&:to_sym)
      formats.all? do |f|
        FORMATS.key? f
      end
    end

    if RUBY_VERSION <= '1.8.7'
      def self.respond_to?(method, include_private=false)
        respond_to_missing? method, include_private
      end
    end

  end

end
