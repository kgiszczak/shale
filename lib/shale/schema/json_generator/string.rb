# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema string type
      #
      # @api private
      class String < Base
        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => 'string',
            'format' => schema[:format],
            'minLength' => schema[:min_length],
            'maxLength' => schema[:max_length],
            'pattern' => schema[:pattern],
            'description' => schema[:description] }.compact
        end
      end
    end
  end
end
