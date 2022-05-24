# frozen_string_literal: true

require_relative '../../shale'
require_relative 'xml_generator/complex_type'
require_relative 'xml_generator/import'
require_relative 'xml_generator/ref_attribute'
require_relative 'xml_generator/ref_element'
require_relative 'xml_generator/schema'
require_relative 'xml_generator/typed_attribute'
require_relative 'xml_generator/typed_element'

module Shale
  module Schema
    # Class for generating XML schema
    #
    # @api public
    class XMLGenerator
      # XML Schema default name
      # @api private
      DEFAULT_SCHEMA_NAME = 'schema'

      @xml_types = Hash.new('string')

      # Register Shale to XML type mapping
      #
      # @param [Shale::Type::Value] shale_type
      # @param [String] xml_type
      #
      # @example
      #   Shale::Schema::XMLGenerator.register_xml_type(Shale::Type::String, 'myType')
      #
      # @api public
      def self.register_xml_type(shale_type, xml_type)
        @xml_types[shale_type] = xml_type
      end

      # Return XML type for given Shale type
      #
      # @param [Shale::Type::Value] shale_type
      #
      # @return [String]
      #
      # @example
      #   Shale::Schema::XMLGenerator.get_xml_type(Shale::Type::String)
      #   # => 'string'
      #
      # @api private
      def self.get_xml_type(shale_type)
        @xml_types[shale_type]
      end

      register_xml_type(Shale::Type::Boolean, 'boolean')
      register_xml_type(Shale::Type::Date, 'date')
      register_xml_type(Shale::Type::Float, 'decimal')
      register_xml_type(Shale::Type::Integer, 'integer')
      register_xml_type(Shale::Type::Time, 'dateTime')
      register_xml_type(Shale::Type::Value, 'anyType')

      # Generate XML Schema from Shale model and return
      # it as a Shale::Schema::XMLGenerator::Schema array
      #
      # @param [Shale::Mapper] klass
      # @param [String, nil] base_name
      #
      # @raise [NotAShaleMapperError] when attribute is not a Shale model
      #
      # @return [Array<Shale::Schema::XMLGenerator::Schema>]
      #
      # @example
      #   Shale::Schema::XMLGenerator.new.as_schemas(Person)
      #
      # @api public
      def as_schemas(klass, base_name = nil)
        unless mapper_type?(klass)
          raise NotAShaleMapperError, "XML Shema can't be generated for '#{klass}' type"
        end

        schemas = Hash.new do |hash, key|
          name = "#{base_name || DEFAULT_SCHEMA_NAME}#{hash.keys.length}.xsd"
          hash[key] = Schema.new(name, key)
        end

        default_namespace = klass.xml_mapping.default_namespace

        root_element = TypedElement.new(
          name: klass.xml_mapping.unprefixed_root,
          type: [default_namespace.prefix, schematize(klass.name)].compact.join(':'),
          required: true
        )

        schemas[default_namespace.name].add_namespace(
          default_namespace.prefix,
          default_namespace.name
        )
        schemas[default_namespace.name].add_child(root_element)

        composites = []
        collect_composite_types(composites, klass, klass.xml_mapping.default_namespace.name)

        composites.each do |composite|
          type = composite[:type]
          namespace = composite[:namespace]
          children = []

          type.xml_mapping.elements.values.each do |mapping|
            attribute = type.attributes[mapping.attribute]
            next unless attribute

            xml_type = get_xml_type_for_attribute(attribute.type, mapping.namespace)
            default = get_default_for_attribute(attribute)

            if namespace == mapping.namespace.name
              children << TypedElement.new(
                name: mapping.name,
                type: xml_type,
                collection: attribute.collection?,
                default: default
              )
            else
              target_namespace = mapping.namespace
              target_schema = schemas[target_namespace.name]

              children << RefElement.new(
                ref: mapping.prefixed_name,
                collection: attribute.collection?,
                default: default
              )

              target_element = TypedElement.new(
                name: mapping.name,
                type: xml_type,
                required: true
              )

              import_element = Import.new(
                target_namespace.name,
                target_schema.name
              )

              target_schema.add_namespace(
                target_namespace.prefix,
                target_namespace.name
              )
              target_schema.add_child(target_element)

              schemas[namespace].add_namespace(
                target_namespace.prefix,
                target_namespace.name
              )
              schemas[namespace].add_child(import_element)
            end
          end

          type.xml_mapping.attributes.values.each do |mapping|
            attribute = type.attributes[mapping.attribute]
            next unless attribute

            xml_type = get_xml_type_for_attribute(attribute.type, mapping.namespace)
            default = get_default_for_attribute(attribute)

            if namespace == mapping.namespace.name
              children << TypedAttribute.new(
                name: mapping.name,
                type: xml_type,
                default: default
              )
            else
              target_namespace = mapping.namespace
              target_schema = schemas[target_namespace.name]

              children << RefAttribute.new(
                ref: mapping.prefixed_name,
                default: default
              )

              target_element = TypedAttribute.new(name: mapping.name, type: xml_type)

              import_element = Import.new(
                target_namespace.name,
                target_schema.name
              )

              target_schema.add_namespace(
                target_namespace.prefix,
                target_namespace.name
              )
              target_schema.add_child(target_element)

              schemas[namespace].add_namespace(
                target_namespace.prefix,
                target_namespace.name
              )
              schemas[namespace].add_child(import_element)
            end
          end

          complex = ComplexType.new(
            schematize(type.name),
            children,
            mixed: !type.xml_mapping.content.nil?
          )

          schemas[namespace].add_child(complex)
        end

        schemas.values
      end

      # Generate XML Schema from Shale model
      #
      # @param [Shale::Mapper] klass
      # @param [String, nil] base_name
      # @param [true, false] pretty
      # @param [true, false] declaration
      #
      # @return [Hash<String, String>]
      #
      # @example
      #   Shale::Schema::XMLGenerator.new.to_schemas(Person)
      #
      # @api public
      def to_schemas(klass, base_name = nil, pretty: false, declaration: false)
        schemas = as_schemas(klass, base_name)

        options = [
          pretty ? :pretty : nil,
          declaration ? :declaration : nil,
        ]

        schemas.to_h do |schema|
          [schema.name, Shale.xml_adapter.dump(schema.as_xml, *options)]
        end
      end

      private

      # Check it type inherits from Shale::Mapper
      #
      # @param [Class] type
      #
      # @return [true, false]
      #
      # @api private
      def mapper_type?(type)
        type < Shale::Mapper
      end

      # Collect recursively Shale::Mapper types
      #
      # @param [Array<Shale::Mapper>] types
      # @param [Shale::Mapper] type
      # @param [String, nil] namespace
      #
      # @api private
      def collect_composite_types(types, type, namespace)
        types << { type: type, namespace: namespace }

        type.xml_mapping.elements.values.each do |mapping|
          attribute = type.attributes[mapping.attribute]
          next unless attribute

          is_mapper = mapper_type?(attribute.type)
          is_included = types.include?({ type: attribute.type, namespace: namespace })

          if is_mapper && !is_included
            collect_composite_types(types, attribute.type, mapping.namespace.name)
          end
        end
      end

      # Convert Ruby class name to XML Schema name
      #
      # @param [String] word
      #
      # @return [String]
      #
      # @api private
      def schematize(word)
        word.gsub('::', '_')
      end

      # Return XML Schema type for given Shale::Type::Value
      #
      # @param [Shale::Type::Value] type
      # @param [String] namespace
      #
      # @return [String]
      #
      # @api private
      def get_xml_type_for_attribute(type, namespace)
        if mapper_type?(type)
          [namespace.prefix, schematize(type.name)].compact.join(':')
        else
          "xs:#{self.class.get_xml_type(type)}"
        end
      end

      # Return default value for given Shale::Attribute
      #
      # @param [Shale::Attribute] attribute
      #
      # @return [String, nil]
      #
      # @api private
      def get_default_for_attribute(attribute)
        return unless attribute.default
        return if attribute.collection?
        return if mapper_type?(attribute.type)

        value = attribute.type.cast(attribute.default.call)
        attribute.type.as_xml_value(value)
      end
    end
  end
end
