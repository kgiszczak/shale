# frozen_string_literal: true

require_relative 'dict'

module Shale
  module Mapping
    module Group
      # Xml group descriptor
      #
      # @api private
      class Xml < Dict
        # Initialize instance
        #
        # @param [Symbol] method_from
        # @param [Symbol] method_to
        #
        # @api private
        def initialize(method_from, method_to)
          super(method_from, method_to)
          @dict = { content: nil, attributes: {}, elements: {} }
        end

        # Add key-value pair to a group
        #
        # @param [Symbol] kind
        # @param [String] key
        # @param [any] value
        #
        # @api private
        def add(kind, key, value)
          case kind
          when :content
            @dict[:content] = value
          when :attribute
            @dict[:attributes][key] = value
          when :element
            @dict[:elements][key] = value
          end
        end
      end
    end
  end
end
