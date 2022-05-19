# frozen_string_literal: true

require_relative 'attribute'

module Shale
  module Schema
    class XMLGenerator
      # Class representing XML Schema <attribute ref=""> element
      # with a reference
      #
      # @api private
      class RefAttribute < Attribute
        # Initialize RefAttribute object
        #
        # @param [String] ref
        # @param [String, nil] default
        #
        # @api private
        def initialize(ref:, default: nil)
          super(default)
          @ref = ref
        end

        private

        # Return attributes as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def attributes
          { 'ref' => @ref }
        end
      end
    end
  end
end
