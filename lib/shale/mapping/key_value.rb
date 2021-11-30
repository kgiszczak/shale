# frozen_string_literal: true

module Shale
  module Mapping
    # Mapping for key/value serialization formats (Hash/JSON/YAML)
    #
    # @api private
    class KeyValue
      # Return keys mapping hash
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :keys

      # Initialize instance
      #
      # @api private
      def initialize
        @keys = {}
      end

      # Map key to attribute
      #
      # @param [String] key Document's key
      # @param [Symbol] to Object's attribute
      #
      # @api private
      def map(key, to:)
        @keys[key] = to
      end

      # @api private
      def initialize_dup(other)
        @keys = other.instance_variable_get('@keys').dup
        super
      end
    end
  end
end
