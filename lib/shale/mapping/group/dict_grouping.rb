# frozen_string_literal: true

require_relative 'dict'

module Shale
  module Mapping
    module Group
      # Class representing mapping group for JSON/YAML/TOML
      #
      # @api private
      class DictGrouping
        # Initialize instance
        #
        # @api private
        def initialize
          @groups = {}
        end

        # Add a value to a group
        #
        # @param [Shale::Mapping::Descriptor::Dict] mapping
        # @param [any] value
        #
        # @api private
        def add(mapping, value)
          group = @groups[mapping.group] ||= Dict.new(mapping.method_from, mapping.method_to)
          group.add(mapping.name, value)
        end

        # Iterate over groups
        #
        # @param [Proc] block
        #
        # @api private
        def each(&block)
          @groups.values.each(&block)
        end
      end
    end
  end
end
