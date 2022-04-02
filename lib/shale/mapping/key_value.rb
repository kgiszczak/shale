# frozen_string_literal: true

require_relative 'base'
require_relative 'descriptor'

module Shale
  module Mapping
    # Mapping for key/value serialization formats (Hash/JSON/YAML)
    #
    # @api private
    class KeyValue < Base
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
        super
        @keys = {}
      end

      # Map key to attribute
      #
      # @param [String] key Document's key
      # @param [Symbol, nil] to Object's attribute
      # @param [Hash, nil] using
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map(key, to: nil, using: nil)
        validate_arguments(key, to, using)
        @keys[key] = Descriptor.new(name: key, attribute: to, methods: using)
      end

      # @api private
      def initialize_dup(other)
        @keys = other.instance_variable_get('@keys').dup
        super
      end
    end
  end
end
