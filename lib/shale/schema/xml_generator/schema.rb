# frozen_string_literal: true

require_relative '../../../shale'
require_relative 'complex_type'

module Shale
  module Schema
    class XMLGenerator
      class Schema
        # XML Schema namespace
        # @api private
        NAMESPACE_NAME = 'http://www.w3.org/2001/XMLSchema'

        # Return name
        #
        # @return [String]
        #
        # @api private
        attr_reader :name

        # Initialize Schema object
        #
        # @param [String] name
        # @param [String, nil] target_namespace
        #
        # @api private
        def initialize(name, target_namespace)
          @name = name
          @target_namespace = target_namespace
          @namespaces = []
          @children = []
        end

        # Add namespace to XML Schema
        #
        # @param [String] prefix
        # @param [String] name
        #
        # @api private
        def add_namespace(prefix, name)
          @namespaces << { prefix: prefix, name: name }
        end

        # Add child element to XML Schema
        #
        # @param [Shale::Schema::XMLGenerator::Import,
        #         Shale::Schema::XMLGenerator::Element,
        #         Shale::Schema::XMLGenerator::Attribute,
        #         Shale::Schema::XMLGenerator::ComplesType] child
        #
        # @api private
        def add_child(child)
          @children << child
        end

        # Append element to the XML document
        #
        # @param [Shale::Adapter::<XML adapter>::Document] doc
        #
        # @return [Shale::Adapter::REXML::Document,
        #          Shale::Adapter::Nokogiri::Document,
        #          Shale::Adapter::Ox::Document]
        #
        # @api private
        def as_xml
          doc = Shale.xml_adapter.create_document
          doc.add_namespace('xs', NAMESPACE_NAME)

          @namespaces.uniq.each do |namespace|
            doc.add_namespace(namespace[:prefix], namespace[:name])
          end

          schema = doc.create_element('xs:schema')
          doc.add_element(doc.doc, schema)

          doc.add_attribute(schema, 'elementFormDefault', 'qualified')
          doc.add_attribute(schema, 'attributeFormDefault', 'qualified')

          unless @target_namespace.nil?
            doc.add_attribute(schema, 'targetNamespace', @target_namespace)
          end

          imports = @children
            .select { |e| e.is_a?(Import) }
            .uniq(&:namespace)
            .sort { |a, b| (a.namespace || '') <=> (b.namespace || '') }

          elements = @children
            .select { |e| e.is_a?(Element) }
            .sort { |a, b| a.name <=> b.name }

          attributes = @children
            .select { |e| e.is_a?(Attribute) }
            .sort { |a, b| a.name <=> b.name }

          complex_types = @children
            .select { |e| e.is_a?(ComplexType) }
            .sort { |a, b| a.name <=> b.name }

          imports.each do |import|
            doc.add_element(schema, import.as_xml(doc))
          end

          elements.each do |element|
            doc.add_element(schema, element.as_xml(doc))
          end

          attributes.each do |attribute|
            doc.add_element(schema, attribute.as_xml(doc))
          end

          complex_types.each do |complex_type|
            doc.add_element(schema, complex_type.as_xml(doc))
          end

          doc.doc
        end
      end
    end
  end
end
