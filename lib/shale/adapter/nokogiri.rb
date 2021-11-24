# frozen_string_literal: true

require 'nokogiri'

module Shale
  module Adapter
    module Nokogiri
      def self.load(xml)
        doc = ::Nokogiri::XML::Document.parse(xml) do |config|
          config.noblanks
        end

        Node.new(doc.root)
      end

      def self.dump(doc)
        doc.to_xml
      end

      def self.create_document
        Document.new
      end

      class Document
        attr_reader :doc

        def initialize
          @doc = ::Nokogiri::XML::Document.new
        end

        def create_element(name)
          ::Nokogiri::XML::Element.new(name, @doc)
        end

        def add_attribute(element, name, value)
          element[name] = value
        end

        def add_element(element, child)
          element.add_child(child)
        end

        def add_text(element, text)
          element.content = text
        end
      end

      class Node
        def initialize(node)
          @node = node
        end

        def name
          [@node.namespace&.prefix, @node.name].compact.join(':')
        end

        def attributes
          @node.attribute_nodes.each_with_object({}) do |node, hash|
            name = [node.namespace&.prefix, node.name].compact.join(':')
            hash[name] = node.value
          end
        end

        def children
          @node
            .children
            .to_a
            .filter(&:element?)
            .map { |e| self.class.new(e) }
        end

        def text
          first = @node
            .children
            .to_a
            .filter(&:text?)
            .first

          first.text if first
        end
      end
    end
  end
end
