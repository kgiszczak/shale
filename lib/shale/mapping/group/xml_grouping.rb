# frozen_string_literal: true

require_relative 'dict_grouping'
require_relative 'xml'

module Shale
  module Mapping
    module Group
      # Class representing mapping group for XML
      #
      # @api private
      class XmlGrouping < DictGrouping
        # Add a value to a group
        #
        # @param [Shale::Mapping::Descriptor::Dict] mapping
        # @param [Symbol] kind
        # @param [any] value
        #
        # @api private
        def add(mapping, kind, value)
          group = @groups[mapping.group] ||= Xml.new(mapping.method_from, mapping.method_to)
          group.add(kind, mapping.namespaced_name, value)
        end
      end
    end
  end
end
