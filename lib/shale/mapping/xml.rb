# frozen_string_literal: true

require_relative 'xml_base'
require_relative 'xml_group'

module Shale
  module Mapping
    # Mapping for XML serialization format
    #
    # @api private
    class Xml < XmlBase
      # Map element to attribute
      #
      # @param [String] element
      # @param [Symbol, nil] to
      # @param [Hash, nil] using
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      # @param [true, false] cdata
      # @param [true, false] render_nil
      #
      # @api private
      def map_element(
        element,
        to: nil,
        using: nil,
        namespace: :undefined,
        prefix: :undefined,
        cdata: false,
        render_nil: false
      )
        super(
          element,
          to: to,
          using: using,
          namespace: namespace,
          prefix: prefix,
          cdata: cdata,
          render_nil: render_nil
        )
      end

      # Map document's attribute to object's attribute
      #
      # @param [String] attribute
      # @param [Symbol, nil] to
      # @param [Hash, nil] using
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      # @param [true, false] render_nil
      #
      # @api private
      def map_attribute(
        attribute,
        to: nil,
        using: nil,
        namespace: nil,
        prefix: nil,
        render_nil: false
      )
        super(
          attribute,
          to: to,
          using: using,
          namespace: namespace,
          prefix: prefix,
          render_nil: render_nil
        )
      end

      # Map document's content to object's attribute
      #
      # @param [Symbol] to
      # @param [Hash, nil] using
      # @param [true, false] cdata
      #
      # @api private
      def map_content(to: nil, using: nil, cdata: false)
        super(to: to, using: using, cdata: cdata)
      end

      # Map group of nodes to mapping methods
      #
      # @param [Symbol] from
      # @param [Symbol] to
      # @param [Proc] block
      #
      # @api private
      def using(from:, to:, &block)
        group = XmlGroup.new(from, to)

        group.namespace(default_namespace.name, default_namespace.prefix)
        group.instance_eval(&block)

        @elements.merge!(group.elements)
        @attributes.merge!(group.attributes)
        @content = group.content if group.content
      end
    end
  end
end
