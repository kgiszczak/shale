# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema reference
      #
      # @api private
      class Ref < Base
        def initialize(name, type, schema: nil)
          super(name, schema: schema)
          @type = type.gsub('::', '_')
        end

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { '$ref' => "#/$defs/#{@type}" }
        end
      end
    end
  end
end
