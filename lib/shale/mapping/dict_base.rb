# frozen_string_literal: true

require_relative 'descriptor/dict'
require_relative 'validator'

module Shale
  module Mapping
    # Base class for Mapping dictionary serialization formats (Hash/JSON/YAML)
    #
    # @api private
    class DictBase
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
        @finalized = false
      end

      # Map key to attribute
      #
      # @param [String] key
      # @param [Symbol, nil] to
      # @param [Hash, nil] using
      # @param [String, nil] group
      # @param [true, false] render_nil
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map(key, to: nil, using: nil, group: nil, render_nil: false)
        Validator.validate_arguments(key, to, using)
        @keys[key] = Descriptor::Dict.new(
          name: key,
          attribute: to,
          methods: using,
          group: group,
          render_nil: render_nil
        )
      end

      # Set the "finalized" instance variable to true
      #
      # @api private
      def finalize!
        @finalized = true
      end

      # Query the "finalized" instance variable
      #
      # @return [truem false]
      #
      # @api private
      def finalized?
        @finalized
      end

      # @api private
      def initialize_dup(other)
        @keys = other.instance_variable_get('@keys').dup
        @finalized = false
        super
      end
    end
  end
end
