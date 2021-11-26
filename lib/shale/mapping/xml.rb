# frozen_string_literal: true

module Shale
  module Mapping
    class Xml
      attr_reader :elements, :attributes, :content

      def initialize
        @elements = {}
        @attributes = {}
        @content = nil
        @root = ''
      end

      def map_element(element, to:)
        @elements[element] = to
      end

      def map_attribute(attribute, to:)
        @attributes[attribute] = to
      end

      def map_content(to:)
        @content = to
      end

      def root(value = nil)
        value.nil? ? @root : @root = value
      end

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
