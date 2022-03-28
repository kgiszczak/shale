# frozen_string_literal: true

module Shale
  module Mapping
    class Mapping
      # Return attribute name
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :attribute

      # Return method symbol
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :method_from

      # Return method symbol
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :method_to

      # Initialize instance
      #
      # @param [Symbol] attribute
      # @param [Hash] methods
      #
      # @api private
      def initialize(attribute:, methods:)
        @attribute = attribute

        if methods
          @method_from = methods[:from]
          @method_to = methods[:to]
        end
      end
    end
  end
end
