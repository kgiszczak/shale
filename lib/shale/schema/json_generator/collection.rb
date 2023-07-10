# frozen_string_literal: true

module Shale
  module Schema
    class JSONGenerator
      # Class representing array type in JSON Schema
      #
      # @api private
      class Collection < Base

        def initialize(type, **kwargs)
          super(type.name, **kwargs)
          @type = type
        end

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_json
          { 'type' => 'array', 'items' => @type.as_type }
        end
      end
    end
  end
end
