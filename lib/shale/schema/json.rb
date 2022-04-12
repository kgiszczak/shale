# frozen_string_literal: true

require_relative '../../shale'

module Shale
  module Schema
    # Module for handling JSON schema
    #
    # @api private
    class JSON
      # JSON type wrapper
      # @api private
      JsonType = Struct.new(:type, :format)

      # Default JSON type
      # @api private
      DEFAULT_TYPE = JsonType.new('string')

      # Shale to JSON type mapping
      # @api private
      TYPE_MAPPING = {
        Type::Boolean => JsonType.new('boolean'),
        Type::Date => JsonType.new('string', 'date'),
        Type::Float => JsonType.new('number'),
        Type::Integer => JsonType.new('integer'),
        Type::String => JsonType.new('string'),
        Type::Time => JsonType.new('string', 'date-time'),
        Type::Value => JsonType.new('string'),
      }.freeze

      # JSON Schema dialect (aka version)
      # @api private
      DIALECT = 'https://json-schema.org/draft/2020-12/schema'

      # Generate JSON Schema from Shale model and return it as a Ruby Hash
      #
      # @param [Shale::Mapper] klass
      # @param [String, nil] id
      # @param [String, nil] description
      #
      # @raise [NotAShaleMapperError] when attribute is not a Shale model
      #
      # @return [Hash]
      #
      # @example
      #   Shale::Schema::JSON.new.as_schema(Person)
      #
      # @api private
      def as_schema(klass, id: nil, description: nil)
        unless mapper_type?(klass)
          raise NotAShaleMapperError, "JSON Shema can't be generated for '#{klass}' type"
        end

        types = collect_composite_types(klass)
          .uniq
          .sort { |a, b| a.name <=> b.name }

        defs = {}

        types.each do |type|
          defs[schematize(type.name)] = defs_for_type(klass, type)
        end

        {
          '$schema' => DIALECT,
          'id' => id,
          'description' => description,
          '$ref' => "#/$defs/#{schematize(klass.name)}",
          '$defs' => defs,
        }.compact
      end

      # Generate JSON Schema from Shale model
      #
      # @param [Shale::Mapper] klass
      # @param [String, nil] id
      # @param [String, nil] description
      # @param [true, false] pretty
      #
      # @return [String]
      #
      # @example
      #   Shale::Schema::JSON.new.to_schema(Person)
      #
      # @api private
      def to_schema(klass, id: nil, description: nil, pretty: false)
        schema = as_schema(klass, id: id, description: description)
        options = pretty ? :pretty : nil

        Shale.json_adapter.dump(schema, options)
      end

      private

      # Return JSON Schema definitions
      #
      # @param [Shale::Mapper] root_klass
      # @param [Shale::Mapper] type
      #
      # @return [Hash]
      #
      # @api private
      def defs_for_type(root_klass, type)
        props = {}

        type.json_mapping.keys.values.each do |mapping|
          attribute = type.attributes[mapping.attribute]
          next unless attribute

          props[mapping.name] = props_for_attribute(attribute)
        end

        {
          'type' => root_klass == type ? 'object' : %w[object null],
          'properties' => props,
        }
      end

      # Return JSON Schema type properties
      #
      # @param [Shale::Attribute] attribute
      #
      # @return [Hash]
      #
      # @api private
      def props_for_attribute(attribute)
        prop = {}

        if mapper_type?(attribute.type)
          prop = { '$ref' => "#/$defs/#{schematize(attribute.type.name)}" }
        else
          maped_type = to_json_type(attribute.type)
          json_type = [maped_type.type, 'null']

          if attribute.collection?
            json_type = maped_type.type
          elsif attribute.default
            type_casted_value = attribute.type.cast(attribute.default.call)
            default = attribute.type.as_json(type_casted_value)
          end

          prop = {
            'type' => json_type,
            'format' => maped_type.format,
            'default' => default,
          }.compact
        end

        if attribute.collection?
          prop = {
            'type' => 'array',
            'items' => prop,
          }
        end

        prop
      end

      # Get JSON type from Shale type
      #
      # @param [Shale::Type::Value] type
      #
      # @return [JsonType]
      #
      # @api private
      def to_json_type(type)
        TYPE_MAPPING.fetch(type, DEFAULT_TYPE)
      end

      # Check it type inherits from Shale::Mapper
      #
      # @param [Shale::Mapper] type
      #
      # @return [true, false]
      #
      # @api private
      def mapper_type?(type)
        type < Shale::Mapper
      end

      # Collect recursively Shale::Mapper types
      #
      # @param [Shale::Mapper] type
      #
      # @return [Array<Shale::Mapper>]
      #
      # @api private
      def collect_composite_types(type)
        types = [type]

        type.json_mapping.keys.values.each do |mapping|
          attribute = type.attributes[mapping.attribute]
          next unless attribute

          if mapper_type?(attribute.type)
            types += collect_composite_types(attribute.type)
          end
        end

        types
      end

      # Convert Ruby class name to identifier accepted by JSON Schema
      #
      # @param [String] word
      #
      # @return [String]
      #
      # @api private
      def schematize(word)
        word.gsub('::', '_')
      end
    end
  end
end
