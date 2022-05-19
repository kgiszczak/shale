# frozen_string_literal: true

require_relative 'attribute'

module Shale
  module Schema
    class XMLGenerator
      # Class representing XML Schema <attribute name="" type=""> element
      # with a name and a type
      #
      # @api private
      class TypedAttribute < Attribute
        # Return name
        #
        # @return [String]
        #
        # @api private
        attr_reader :name

        # Initialize TypedAttribute object
        #
        # @param [String] name
        # @param [String] type
        # @param [String, nil] default
        #
        # @api private
        def initialize(name:, type:, default: nil)
          super(default)
          @name = name
          @type = type
        end

        private

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
