# frozen_string_literal: true

module Shale
  module Adapter
    module Nokogiri
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

        # Return namespaces defined on document
        #
        # @return [Hash<String, String>]
        #
        # @example
        #   node.namespaces # => { 'foo' => 'http://foo.com', 'bar' => 'http://bar.com' }
        #
        # @api private
        def namespaces
          @node.namespaces.transform_keys { |e| e.sub('xmlns:', '') }
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
          [@node.namespace&.href, @node.name].compact.join(':')
        end

        # Return all attributes associated with the node
        #
        # @return [Hash]
        #
        # @api private
        def attributes
          @node.attribute_nodes.each_with_object({}) do |node, hash|
            name = [node.namespace&.href, node.name].compact.join(':')
            hash[name] = node.value
          end
        end

        # Return node's parent
        #
        # @return [Shale::Adapter::Nokogiri::Node, nil]
        #
        # @api private
        def parent
          if @node.respond_to?(:parent) && @node.parent && @node.parent.name != 'document'
            self.class.new(@node.parent)
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
