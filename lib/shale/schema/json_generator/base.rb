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

        # Return default
        #
        # @api private
        attr_reader :default

        # Return nullable
        #
        # @api private
        attr_writer :nullable

        # Return properties
        #
        # @api private
        attr_reader :properties

        # Return properties
        #
        # @api private
        attr_reader :required

        def initialize(name, default: nil, nullable: true, properties: nil, required: false)
          @name = name.gsub('::', '_')
          @default = default
          @nullable = nullable
          @properties = properties
          @required = required
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
