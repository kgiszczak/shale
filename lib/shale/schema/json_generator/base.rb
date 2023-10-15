# frozen_string_literal: true

module Shale
  module Schema
    class JSONGenerator
      # Base class for JSON Schema types
      #
      # @api private
      class Base
        # Return name
        #
        # @api private
        attr_reader :name

        # Return schema hash
        #
        # @api private
        attr_reader :schema

        # Set nullable
        #
        # @api private
        attr_writer :nullable

        def initialize(name, default: nil, schema: nil)
          @name = name.gsub('::', '_')
          @default = default
          @schema = schema || {}
          @nullable = !schema&.[](:required)
        end

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_json
          type = as_type
          type['type'] = [*type['type'], 'null'] if type['type'] && @nullable
          type['default'] = @default unless @default.nil?

          type
        end
      end
    end
  end
end
