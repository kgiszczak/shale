# frozen_string_literal: true

require_relative 'base'
require_relative 'mapping'

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
      # @param [Symbol] to Object's attribute
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map(key, to: nil, using: nil)
        validate_arguments(key, to, using)
        @keys[key] = Mapping.new(attribute: to, methods: using)
      end

      # @api private
      def initialize_dup(other)
        @keys = other.instance_variable_get('@keys').dup
        super
      end
    end
  end
end
