# frozen_string_literal: true

require_relative 'property'

module Shale
  module Schema
    module Compiler
      # Class representing Shale's property
      #
      # @api private
      class XMLProperty < Property
        # Return namespace URI
        #
        # @return [String]
        #
        # @api private
        attr_reader :namespace

        # Return namespace prefix
        #
        # @return [String]
        #
        # @api private
        attr_reader :prefix

        # Initialize object
        #
        # @param [String] name
        # @param [Shale::Schema::Compiler::Type] type
        # @param [true, false] collection
        # @param [Object] default
        # @param [String] prefix
        # @param [String] namespace
        # @param [Symbol] category
        #
        # @api private
        def initialize(name:, type:, collection:, default:, prefix:, namespace:, category:)
          super(name, type, collection, default)
          @prefix = prefix
          @namespace = namespace
          @category = category
        end

        # Check if property's category is content
        #
        # @return [true, false]
        #
        # @api private
        def content?
          @category == :content
        end

        # Check if property's category is attribute
        #
        # @return [true, false]
        #
        # @api private
        def attribute?
          @category == :attribute
        end

        # Check if property's category is element
        #
        # @return [true, false]
        #
        # @api private
        def element?
          @category == :element
        end
      end
    end
  end
end
