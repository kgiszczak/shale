# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema boolean type
      #
      # @api private
      class Boolean < Base
        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => 'boolean',
            'description' => schema[:description] }.compact
        end
      end
    end
  end
end
