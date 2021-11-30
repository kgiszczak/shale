# frozen_string_literal: true

module Shale
  module Mapping
    class Xml
      # Return elements mapping hash
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :elements

      # Return attributes mapping hash
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :attributes

      # Return content mapping
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :content

      # Initialize instance
      #
      # @api private
      def initialize
        @elements = {}
        @attributes = {}
        @content = nil
        @root = ''
      end

      # Map element to attribute
      #
      # @param [String] element Document's element
      # @param [Symbol] to Object's attribute
      #
      # @api private
      def map_element(element, to:)
        @elements[element] = to
      end

      # Map document's attribute to object's attribute
      #
      # @param [String] attribute Document's attribute
      # @param [Symbol] to Object's attribute
      #
      # @api private
      def map_attribute(attribute, to:)
        @attributes[attribute] = to
      end

      # Map document's content to object's attribute
      #
      # @param [Symbol] to Object's attribute
      #
      # @api private
      def map_content(to:)
        @content = to
      end

      # Name document's element
      #
      # @param [String, nil] value Document's element name
      #
      # @return [Stirng, nil]
      #
      # @api private
      def root(value = nil)
        value.nil? ? @root : @root = value
      end

      # @api private
      def initialize_dup(other)
        @elements = other.instance_variable_get('@elements').dup
        @attributes = other.instance_variable_get('@attributes').dup
        @content = other.instance_variable_get('@content').dup
        @root = other.instance_variable_get('@root').dup
        super
      end
    end
  end
end
