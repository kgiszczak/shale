# frozen_string_literal: true

require_relative 'element'

module Shale
  module Schema
    class XMLGenerator
      # Class representing XML Schema <element ref=""> element
      # with a reference
      #
      # @api private
      class RefElement < Element
        # Initialize RefElement object
        #
        # @param [String] ref
        # @param [String, nil] default
        # @param [true, false] collection
        # @param [true, false] required
        #
        # @api private
        def initialize(ref:, default: nil, collection: false, required: false)
          super(default, collection, required)
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
