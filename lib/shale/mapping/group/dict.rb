# frozen_string_literal: true

module Shale
  module Mapping
    module Group
      # Dict group descriptor
      #
      # @api private
      class Dict
        # Return method_from
        #
        # @return [Symbol]
        #
        # @api private
        attr_reader :method_from

        # Return method_to
        #
        # @return [Symbol]
        #
        # @api private
        attr_reader :method_to

        # Return dict hash
        #
        # @return [Hash]
        #
        # @api private
        attr_reader :dict

        # Initialize instance
        #
        # @param [Symbol] method_from
        # @param [Symbol] method_to
        #
        # @api private
        def initialize(method_from, method_to)
          @method_from = method_from
          @method_to = method_to
          @dict = {}
        end

        # Add key-value pair to a group
        #
        # @param [String] key
        # @param [any] value
        #
        # @api private
        def add(key, value)
          @dict[key] = value
        end
      end
    end
  end
end
