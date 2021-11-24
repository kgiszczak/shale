# frozen_string_literal: true

require 'rexml/document'

module Shale
  module Adapter
    module REXML
      def self.load(xml)
        doc = ::REXML::Document.new(xml, ignore_whitespace_nodes: :all)
        Node.new(doc.root)
      end

      def self.dump(doc)
        doc.to_s
      end

      def self.create_document
        Document.new
      end

      class Document
        attr_reader :doc

        def initialize
          @doc = ::REXML::Document.new
        end

        def create_element(name)
          ::REXML::Element.new(name)
        end

        def add_attribute(element, name, value)
          element.add_attribute(name, value)
        end

        def add_element(element, child)
          element.add_element(child)
        end

        def add_text(element, text)
          element.add_text(text)
        end
      end

      class Node
        def initialize(node)
          @node = node
        end

        def name
          @node.expanded_name
        end

        def attributes
          @node.attributes
        end

        def children
          @node
            .children
            .filter { |e| e.node_type == :element }
            .map { |e| self.class.new(e) }
        end

        def text
          @node.text
        end
      end
    end
  end
end
