# frozen_string_literal: true

module Shale
  module Adapter
    module Ox
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

        # Return namespaces defined on document (Not supported by Ox)
        #
        # @return [Hash<String, String>]
        #
        # @example
        #   node.namespaces # => {}
        #
        # @api private
        def namespaces
          {}
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

        # Return node's parent (Not supported by OX)
        #
        # @return [nil]
        #
        # @api private
        def parent
          # :noop:
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
          texts = @node.nodes.map do |e|
            case e
            when ::Ox::CData
              e.value
            when ::String
              e
            end
          end

          texts.compact.first
        end
      end
    end
  end
end
