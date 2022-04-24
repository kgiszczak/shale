# frozen_string_literal: true

require_relative 'element'

module Shale
  module Schema
    class XML
      # Class representing XML Schema <element mame="" type=""> element
      # with a name and a type
      #
      # @api private
      class TypedElement < Element
        # Return name
        #
        # @return [String]
        #
        # @api private
        attr_reader :name

        # Initialize TypedElement object
        #
        # @param [String] name
        # @param [String] type
        # @param [String, nil] default
        # @param [true, false] collection
        # @param [true, false] required
        #
        # @api private
        def initialize(name:, type:, default: nil, collection: false, required: false)
          super(default, collection, required)
          @name = name
          @type = type
        end

        # Return attributes as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def attributes
          { 'name' => @name, 'type' => @type }
        end
      end
    end
  end
end
