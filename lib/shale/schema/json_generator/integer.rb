# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema integer type
      #
      # @api private
      class Integer < Base
        VALIDATORS = %w(exclusiveMaximum multipleOf exclusiveMinimum maximum minimum)

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => 'integer' }.merge(validators)
        end
      end
    end
  end
end
