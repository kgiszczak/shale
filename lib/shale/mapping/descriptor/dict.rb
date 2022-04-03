# frozen_string_literal: true

module Shale
  module Mapping
    module Descriptor
      # Class representing attribute mapping
      #
      # @api private
      class Dict
        # Return mapping name
        #
        # @return [String]
        #
        # @api private
        attr_reader :name

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
        # @param [String] name
        # @param [Symbol, nil] attribute
        # @param [Hash, nil] methods
        #
        # @api private
        def initialize(name:, attribute:, methods:)
          @name = name
          @attribute = attribute

          if methods
            @method_from = methods[:from]
            @method_to = methods[:to]
          end
        end
      end
    end
  end
end
