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
    #   Shale::Utils.underscore('Namespace::FooBar') # => namespace:foo_bar
    #
    # @api private
    def self.underscore(word)
      word
        .gsub('::', ':')
        .gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .downcase
    end
  end
end
