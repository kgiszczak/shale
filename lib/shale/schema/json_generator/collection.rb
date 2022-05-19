# frozen_string_literal: true

module Shale
  module Schema
    class JSONGenerator
      # Class representing array type in JSON Schema
      #
      # @api private
      class Collection
        # Initialize Collection object
        #
        # @param [Shale::Schema::JSONGenerator::Base] type
        #
        # @api private
        def initialize(type)
          @type = type
        end

        # Delegate name to wrapped type object
        #
        # @return [String]
        #
        # @api private
        def name
          @type.name
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
