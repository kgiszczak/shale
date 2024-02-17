# frozen_string_literal: true

module Shale
  # Utitlity functions
  #
  # @api private
  module Utils
    # Upcase first letter of a string
    #
    # @param [String] val
    #
    # @example
    #   Shale::Utils.upcase_first('fooBar')
    #   # => 'FooBar'
    #
    # @api private
    def self.upcase_first(str)
      return '' unless str
      return '' if str.empty?
      str[0].upcase + str[1..-1]
    end

    # Convert string to Ruby's class naming convention
    #
    # @param [String] val
    #
    # @example
    #   Shale::Utils.classify('foobar')
    #   # => 'Foobar'
    #
    # @api private
    def self.classify(str)
      # names may include a period, which will need to be stripped out
      str = str.to_s.gsub('.', '')

      str = str.sub(/^[a-z\d]*/) { |match| upcase_first(match) || match }

      str.gsub('::', '/').gsub(%r{(?:_|-|(/))([a-z\d]*)}i) do
        word = Regexp.last_match(2)
        substituted = upcase_first(word) || word
        Regexp.last_match(1) ? "::#{substituted}" : substituted
      end
    end

    # Convert string to snake case
    #
    # @param [String] val
    #
    # @example
    #   Shale::Utils.snake_case('FooBar')
    #   # => 'foo_bar'
    #
    # @api private
    def self.snake_case(str)
      # XML elements allow periods and hyphens
      str = str.to_s.gsub('.', '_')
      return str.to_s unless /[A-Z-]|::/.match?(str)
      word = str.to_s.gsub('::', '/')
      word = word.gsub(/([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) do
        "#{Regexp.last_match(1) || Regexp.last_match(2)}_"
      end
      word = word.tr('-', '_')
      word.downcase
    end

    # Convert word to under score
    #
    # @param [String] word
    #
    # @example
    #   Shale::Utils.underscore('FooBar') # => foo_bar
    #   Shale::Utils.underscore('Namespace::FooBar') # => foo_bar
    #
    # @api private
    def self.underscore(str)
      snake_case(str).split('/').last
    end

    # Return value or nil if value is empty
    #
    # @param [String] value
    #
    # @example
    #   Shale::Utils.presence('FooBar') # => FooBar
    #   Shale::Utils.presence('') # => nil
    #
    # @api private
    def self.presence(value)
      return nil unless value
      return nil if value.empty?
      value
    end
  end
end
