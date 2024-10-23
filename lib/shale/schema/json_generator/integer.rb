# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema integer type
      #
      # @api private
      class Integer < Base
        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => 'integer',
            'exclusiveMinimum' => schema[:exclusive_minimum],
            'exclusiveMaximum' => schema[:exclusive_maximum],
            'minimum' => schema[:minimum],
            'maximum' => schema[:maximum],
            'multipleOf' => schema[:multiple_of],
            'description' => schema[:description] }.compact
        end
      end
    end
  end
end
