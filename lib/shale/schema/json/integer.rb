# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSON
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
          { 'type' => 'integer' }
        end
      end
    end
  end
end
