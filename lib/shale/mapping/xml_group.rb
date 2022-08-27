# frozen_string_literal: true

require_relative 'xml_base'

module Shale
  module Mapping
    # Group for XML serialization format
    #
    # @api private
    class XmlGroup < XmlBase
      # Return name of the group
      #
      # @return [String]
      #
      # @api private
      attr_reader :name

      # Initialize instance
      #
      # @api private
      def initialize(from, to)
        super()
        @from = from
        @to = to
        @name = "group_#{hash}"
      end

      # Map element to attribute
      #
      # @param [String] element
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      #
      # @api private
      def map_element(element, namespace: :undefined, prefix: :undefined)
        super(
          element,
          using: { from: @from, to: @to },
          group: @name,
          namespace: namespace,
          prefix: prefix
        )
      end

      # Map document's attribute to object's attribute
      #
      # @param [String] attribute
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      #
      # @api private
      def map_attribute(attribute, namespace: nil, prefix: nil)
        super(
          attribute,
          using: { from: @from, to: @to },
          group: @name,
          namespace: namespace,
          prefix: prefix
        )
      end

      # Map document's content to object's attribute
      #
      # @api private
      def map_content
        super(using: { from: @from, to: @to }, group: @name)
      end
    end
  end
end
