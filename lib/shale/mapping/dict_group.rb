# frozen_string_literal: true

require_relative 'dict_base'

module Shale
  module Mapping
    # Group for dictionary serialization formats (Hash/JSON/YAML)
    #
    # @api private
    class DictGroup < DictBase
      # Return name of the group
      #
      # @return [String]
      #
      # @api private
      attr_reader :name

      # Initialize instance
      #
      # @param [Symbol] from
      # @param [Symbol] to
      #
      # @api private
      def initialize(from, to)
        super()
        @from = from
        @to = to
        @name = "group_#{hash}"
      end

      # Map key to attribute
      #
      # @param [String] key
      #
      # @api private
      def map(key)
        super(key, using: { from: @from, to: @to }, group: @name)
      end
    end
  end
end
