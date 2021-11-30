# frozen_string_literal: true

require 'nokogiri'

module Shale
  module Adapter
    # Nokogiri adapter
    #
    # @api public
    module Nokogiri
      # Parse XML into Nokogiri document
      #
      # @param [String] xml XML document
      #
      # @return [::Nokogiri::XML::Document]
      #
      # @api private
      def self.load(xml)
        doc = ::Nokogiri::XML::Document.parse(xml) do |config|
          config.noblanks
        end

        Node.new(doc.root)
      end

      # Serialize Nokogiri document into XML
      #
      # @param [::Nokogiri::XML::Document] doc Nokogiri document
      #
      # @return [String]
      #
      # @api private
      def self.dump(doc)
        doc.to_xml
      end

      # Create Shale::Adapter::Nokogiri::Document instance
      #
      # @api private
      def self.create_document
        Document.new
      end

      # Wrapper around Nokogiri API
      #
      # @api private
      class Document
        # Return Nokogiri document
        #
        # @return [::Nokogiri::XML::Document]
        #
        # @api private
        attr_reader :doc

        # Initialize object
        #
        # @api private
        def initialize
          @doc = ::Nokogiri::XML::Document.new
        end

        # Create Nokogiri element
        #
        # @param [String] name Name of the XML element
        #
        # @return [::Nokogiri::XML::Element]
        #
        # @api private
        def create_element(name)
          ::Nokogiri::XML::Element.new(name, @doc)
        end

        # Add attribute to Nokogiri element
        #
        # @param [::Nokogiri::XML::Element] element Nokogiri element
        # @param [String] name Name of the XML attribute
        # @param [String] value Value of the XML attribute
        #
        # @api private
        def add_attribute(element, name, value)
          element[name] = value
        end

        # Add child element to Nokogiri element
        #
        # @param [::Nokogiri::XML::Element] element Nokogiri parent element
        # @param [::Nokogiri::XML::Element] child Nokogiri child element
        #
        # @api private
        def add_element(element, child)
          element.add_child(child)
        end

        # Add text node to Nokogiri element
        #
        # @param [::Nokogiri::XML::Element] element Nokogiri element
        # @param [String] text Text to add
        #
        # @api private
        def add_text(element, text)
          element.content = text
        end
      end

      # Wrapper around Nokogiri::XML::Node API
      #
      # @api private
      class Node
        # Initialize object with Nokogiri node
        #
        # @param [::Nokogiri::XML::Node] node Nokogiri node
        #
        # @api private
        def initialize(node)
          @node = node
        end

        # Return fully qualified name of the node in the format of
        # namespace:name when the node is namespaced or just name when it's not
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
          [@node.namespace&.prefix, @node.name].compact.join(':')
        end

        # Return all attributes associated with the node
        #
        # @return [Hash]
        #
        # @api private
        def attributes
          @node.attribute_nodes.each_with_object({}) do |node, hash|
            name = [node.namespace&.prefix, node.name].compact.join(':')
            hash[name] = node.value
          end
        end

        # Return node's element children
        #
        # @return [Array<Shale::Adapter::Nokogiri::Node>]
        #
        # @api private
        def children
          @node
            .children
            .to_a
            .filter(&:element?)
            .map { |e| self.class.new(e) }
        end

        # Return first text child of a node
        #
        # @return [String]
        #
        # @api private
        def text
          first = @node
            .children
            .to_a
            .filter(&:text?)
            .first

          first&.text
        end
      end
    end
  end
end
