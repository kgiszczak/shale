# frozen_string_literal: true

require 'ox'

module Shale
  module Adapter
    # Ox adapter
    #
    # @api public
    module Ox
      # Parse XML into Ox document
      #
      # @param [String] xml XML document
      #
      # @return [::Ox::Document, ::Ox::Element]
      #
      # @api private
      def self.load(xml)
        Node.new(::Ox.parse(xml))
      end

      # Serialize Ox document into XML
      #
      # @param [::Ox::Document, ::Ox::Element] doc Ox document
      #
      # @return [String]
      #
      # @api private
      def self.dump(doc)
        ::Ox.dump(doc)
      end

      # Create Shale::Adapter::Ox::Document instance
      #
      # @api private
      def self.create_document
        Document.new
      end

      # Wrapper around Ox API
      #
      # @api private
      class Document
        # Return Ox document
        #
        # @return [::Ox::Document]
        #
        # @api private
        attr_reader :doc

        # Initialize object
        #
        # @api private
        def initialize
          @doc = ::Ox::Document.new
        end

        # Create Ox element
        #
        # @param [String] name Name of the XML element
        #
        # @return [::Ox::Element]
        #
        # @api private
        def create_element(name)
          ::Ox::Element.new(name)
        end

        # Add XML namespace to document
        #
        # Ox doesn't support XML namespaces so this method does nothing.
        #
        # @param [String] prefix
        # @param [String] namespace
        #
        # @api private
        def add_namespace(prefix, namespace)
          # :noop:
        end

        # Add attribute to Ox element
        #
        # @param [::Ox::Element] element Ox element
        # @param [String] name Name of the XML attribute
        # @param [String] value Value of the XML attribute
        #
        # @api private
        def add_attribute(element, name, value)
          element[name] = value
        end

        # Add child element to Ox element
        #
        # @param [::Ox::Element] element Ox parent element
        # @param [::Ox::Element] child Ox child element
        #
        # @api private
        def add_element(element, child)
          element << child
        end

        # Add text node to Ox element
        #
        # @param [::Ox::Element] element Ox element
        # @param [String] text Text to add
        #
        # @api private
        def add_text(element, text)
          element << text
        end
      end

      # Wrapper around Ox::Element API
      #
      # @api private
      class Node
        # Initialize object with Ox element
        #
        # @param [::Ox::Element] node Ox element
        #
        # @api private
        def initialize(node)
          @node = node
        end

        # Return name of the node in the format of
        # prefix:name when the node is namespaced or just name when it's not
        #
        # @return [String]
        #
        # @example without namespace
        #   node.name # => Bar
        #
        # @example with namespace
        #   node.name # => foo:Bar
        #
        # @api private
        def name
          @node.name
        end

        # Return all attributes associated with the node
        #
        # @return [Hash]
        #
        # @api private
        def attributes
          @node.attributes
        end

        # Return node's element children
        #
        # @return [Array<Shale::Adapter::Ox::Node>]
        #
        # @api private
        def children
          @node
            .nodes
            .filter { |e| e.is_a?(::Ox::Element) }
            .map { |e| self.class.new(e) }
        end

        # Return first text child of a node
        #
        # @return [String]
        #
        # @api private
        def text
          @node.text
        end
      end
    end
  end
end
