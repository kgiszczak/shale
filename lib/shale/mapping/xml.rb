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
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      # @param [true, false] cdata
      # @param [true, false, nil] render_nil
      #
      # @api private
      def map_element(
        element,
        to: nil,
        receiver: nil,
        using: nil,
        namespace: :undefined,
        prefix: :undefined,
        cdata: false,
        render_nil: nil
      )
        super(
          element,
          to: to,
          receiver: receiver,
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
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      # @param [true, false, nil] render_nil
      #
      # @api private
      def map_attribute(
        attribute,
        to: nil,
        receiver: nil,
        using: nil,
        namespace: nil,
        prefix: nil,
        render_nil: nil
      )
        super(
          attribute,
          to: to,
          receiver: receiver,
          using: using,
          namespace: namespace,
          prefix: prefix,
          render_nil: render_nil
        )
      end

      # Map document's content to object's attribute
      #
      # @param [Symbol] to
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      # @param [true, false] cdata
      #
      # @api private
      def map_content(to: nil, receiver: nil, using: nil, cdata: false)
        super(to: to, receiver: receiver, using: using, cdata: cdata)
      end

      # Set render_nil default
      #
      # @param [true, false] val
      #
      # @api private
      def render_nil(val)
        @render_nil_default = val
      end

      # Map group of nodes to mapping methods
      #
      # @param [Symbol] from
      # @param [Symbol] to
      # @param [Proc] block
      #
      # @api private
      def group(from:, to:, &block)
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
