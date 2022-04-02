# frozen_string_literal: true

require 'rexml/document'
require_relative '../utils'

module Shale
  module Adapter
    # REXML adapter
    #
    # @api public
    module REXML
      # Parse XML into REXML document
      #
      # @param [String] xml XML document
      #
      # @return [::REXML::Document]
      #
      # @api private
      def self.load(xml)
        doc = ::REXML::Document.new(xml, ignore_whitespace_nodes: :all)
        Node.new(doc.root)
      end

      # Serialize REXML document into XML
      #
      # @param [::REXML::Document] doc REXML document
      #
      # @return [String]
      #
      # @api private
      def self.dump(doc)
        doc.to_s
      end

      # Create Shale::Adapter::REXML::Document instance
      #
      # @api private
      def self.create_document
        Document.new
      end

      # Wrapper around REXML API
      #
      # @api private
      class Document
        # Initialize object
        #
        # @api private
        def initialize
          @doc = ::REXML::Document.new
          @namespaces = {}
        end

        # Return REXML document
        #
        # @return [::REXML::Document]
        #
        # @api private
        def doc
          if @doc.root
            @namespaces.each do |prefix, namespace|
              @doc.root.add_namespace(prefix, namespace)
            end
          end

          @doc
        end

        # Create REXML element
        #
        # @param [String] name Name of the XML element
        #
        # @return [::REXML::Element]
        #
        # @api private
        def create_element(name)
          ::REXML::Element.new(name)
        end

        # Add XML namespace to document
        #
        # @param [String] prefix
        # @param [String] namespace
        #
        # @api private
        def add_namespace(prefix, namespace)
          @namespaces[prefix] = namespace if prefix && namespace
        end

        # Add attribute to REXML element
        #
        # @param [::REXML::Element] element REXML element
        # @param [String] name Name of the XML attribute
        # @param [String] value Value of the XML attribute
        #
        # @api private
        def add_attribute(element, name, value)
          element.add_attribute(name, value)
        end

        # Add child element to REXML element
        #
        # @param [::REXML::Element] element REXML parent element
        # @param [::REXML::Element] child REXML child element
        #
        # @api private
        def add_element(element, child)
          element.add_element(child)
        end

        # Add text node to REXML element
        #
        # @param [::REXML::Element] element REXML element
        # @param [String] text Text to add
        #
        # @api private
        def add_text(element, text)
          element.add_text(text)
        end
      end

      # Wrapper around REXML::Element API
      #
      # @api private
      class Node
        # Initialize object with REXML element
        #
        # @param [::REXML::Element] node REXML element
        #
        # @api private
        def initialize(node)
          @node = node
        end

        # Return name of the node in the format of
        # namespace:name when the node is namespaced or just name when it's not
        #
        # @return [String]
        #
        # @example without namespace
        #   node.name # => Bar
        #
        # @example with namespace
        #   node.name # => http://foo:Bar
        #
        # @api private
        def name
          [Utils.presence(@node.namespace), @node.name].compact.join(':')
        end

        # Return all attributes associated with the node
        #
        # @return [Hash]
        #
        # @api private
        def attributes
          attributes = @node.attributes.values.map do |attribute|
            attribute.is_a?(Hash) ? attribute.values : attribute
          end.flatten

          attributes.each_with_object({}) do |attribute, hash|
            name = [Utils.presence(attribute.namespace), attribute.name].compact.join(':')
            hash[name] = attribute.value
          end
        end

        # Return node's element children
        #
        # @return [Array<Shale::Adapter::REXML::Node>]
        #
        # @api private
        def children
          @node
            .children
            .filter { |e| e.node_type == :element }
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
