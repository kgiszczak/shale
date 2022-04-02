# frozen_string_literal: true

module Shale
  # Utitlity functions
  #
  # @api private
  module Utils
    # Convert word to under score
    #
    # @param [String] word
    #
    # @example
    #   Shale::Utils.underscore('FooBar') # => foo_bar
    #   Shale::Utils.underscore('Namespace::FooBar') # => foo_bar
    #
    # @api private
    def self.underscore(word)
      word
        .split('::')
        .last
        .gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .downcase
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
