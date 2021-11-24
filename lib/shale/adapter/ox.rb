# frozen_string_literal: true

require 'ox'

module Shale
  module Adapter
    module Ox
      def self.load(xml)
        Node.new(::Ox.parse(xml))
      end

      def self.dump(doc)
        ::Ox.dump(doc)
      end

      def self.create_document
        Document.new
      end

      class Document
        attr_reader :doc

        def initialize
          @doc = ::Ox::Document.new
        end

        def create_element(name)
          ::Ox::Element.new(name)
        end

        def add_attribute(element, name, value)
          element[name] = value
        end

        def add_element(element, child)
          element << child
        end

        def add_text(element, text)
          element << text
        end
      end

      class Node
        def initialize(node)
          @node = node
        end

        def name
          @node.name
        end

        def attributes
          @node.attributes
        end

        def children
          @node
            .nodes
            .filter { |e| e.is_a?(::Ox::Element) }
            .map { |e| self.class.new(e) }
        end

        def text
          @node.text
        end
      end
    end
  end
end
