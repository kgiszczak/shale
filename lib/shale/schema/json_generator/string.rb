# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema string type
      #
      # @api private
      class String < Base
        VALIDATORS = %w(pattern minLength maxLength)

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          { 'type' => 'string' }.merge(validators)
        end
      end
    end
  end
end
