# frozen_string_literal: true

require_relative '../../utils'

module Shale
  module Adapter
    module REXML
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

        # Return namespaces defined on document
        #
        # @return [Hash<String, String>]
        #
        # @example
        #   node.namespaces # => { 'foo' => 'http://foo.com', 'bar' => 'http://bar.com' }
        #
        # @api private
        def namespaces
          @node.namespaces
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

        # Return node's parent
        #
        # @return [Shale::Adapter::REXML::Node, nil]
        #
        # @api private
        def parent
          self.class.new(@node.parent) if @node.parent
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
