# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema any type
      #
      # @api private
      class Value < Base
        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => %w[boolean integer number object string],
            'description' => schema[:description] }.compact
        end
      end
    end
  end
end
