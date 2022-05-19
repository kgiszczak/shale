# frozen_string_literal: true

require_relative 'attribute'
require_relative 'element'

module Shale
  module Schema
    class XMLGenerator
      # Class representing XML Schema <complexType> element
      #
      # @api private
      class ComplexType
        # Return name
        #
        # @return [String]
        #
        # @api private
        attr_reader :name

        # Initialize ComplexType object
        #
        # @param [String] name
        # @param [Array<
        #   Shale::Schema::XMLGenerator::Element,
        #   Shale::Schema::XMLGenerator::Attribute
        # >] children
        # @param [true, false] mixed
        #
        # @api private
        def initialize(name, children = [], mixed: false)
          @name = name
          @children = children
          @mixed = mixed
        end

        # Append element to the XML document
        #
        # @param [Shale::Adapter::<XML adapter>::Document] doc
        #
        # @return [Shale::Adapter::<XML adapter>::Node]
        #
        # @api private
        def as_xml(doc)
          complex_type = doc.create_element('xs:complexType')

          doc.add_attribute(complex_type, 'name', @name)
          doc.add_attribute(complex_type, 'mixed', 'true') if @mixed

          elements = @children.select { |e| e.is_a?(Element) }
          attributes = @children.select { |e| e.is_a?(Attribute) }

          unless elements.empty?
            sequence = doc.create_element('xs:sequence')
            doc.add_element(complex_type, sequence)

            elements.each do |element|
              doc.add_element(sequence, element.as_xml(doc))
            end
          end

          attributes.each do |attribute|
            doc.add_element(complex_type, attribute.as_xml(doc))
          end

          complex_type
        end
      end
    end
  end
end
