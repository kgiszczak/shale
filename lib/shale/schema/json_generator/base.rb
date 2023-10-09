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

        attr_reader :mapping

        # Return nullable
        #
        # @api private
        attr_writer :nullable

        def initialize(name, default: nil, mapping: nil)
          @name = name.gsub('::', '_')
          @default = default
          @mapping = mapping
          @nullable = true
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
