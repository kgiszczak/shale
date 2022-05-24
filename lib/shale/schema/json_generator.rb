# frozen_string_literal: true

require_relative '../../shale'
require_relative 'json_generator/schema'
require_relative 'json_generator/boolean'
require_relative 'json_generator/collection'
require_relative 'json_generator/date'
require_relative 'json_generator/float'
require_relative 'json_generator/integer'
require_relative 'json_generator/object'
require_relative 'json_generator/ref'
require_relative 'json_generator/string'
require_relative 'json_generator/time'
require_relative 'json_generator/value'

module Shale
  module Schema
    # Class for generating JSON schema
    #
    # @api public
    class JSONGenerator
      @json_types = Hash.new(Shale::Schema::JSONGenerator::String)

      # Register Shale to JSON type mapping
      #
      # @param [Shale::Type::Value] shale_type
      # @param [Shale::Schema::JSONGenerator::Base] json_type
      #
      # @example
      #   Shale::Schema::JSONGenerator.register_json_type(Shale::Type::String, MyCustomJsonType)
      #
      # @api public
      def self.register_json_type(shale_type, json_type)
        @json_types[shale_type] = json_type
      end

      # Return JSON type for given Shale type
      #
      # @param [Shale::Type::Value] shale_type
      #
      # @return [Shale::Schema::JSONGenerator::Base]
      #
      # @example
      #   Shale::Schema::JSONGenerator.get_json_type(Shale::Type::String)
      #   # => Shale::Schema::JSON::String
      #
      # @api private
      def self.get_json_type(shale_type)
        @json_types[shale_type]
      end

      register_json_type(Shale::Type::Boolean, Shale::Schema::JSONGenerator::Boolean)
      register_json_type(Shale::Type::Date, Shale::Schema::JSONGenerator::Date)
      register_json_type(Shale::Type::Float, Shale::Schema::JSONGenerator::Float)
      register_json_type(Shale::Type::Integer, Shale::Schema::JSONGenerator::Integer)
      register_json_type(Shale::Type::Time, Shale::Schema::JSONGenerator::Time)
      register_json_type(Shale::Type::Value, Shale::Schema::JSONGenerator::Value)

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
      #   Shale::Schema::JSONGenerator.new.as_schema(Person)
      #
      # @api public
      def as_schema(klass, id: nil, title: nil, description: nil)
        unless mapper_type?(klass)
          raise NotAShaleMapperError, "JSON Shema can't be generated for '#{klass}' type"
        end

        types = []
        collect_composite_types(types, klass)
        objects = []

        types.each do |type|
          properties = []

          type.json_mapping.keys.values.each do |mapping|
            attribute = type.attributes[mapping.attribute]
            next unless attribute

            if mapper_type?(attribute.type)
              json_type = Ref.new(mapping.name, attribute.type.name)
            else
              json_klass = self.class.get_json_type(attribute.type)

              if attribute.default && !attribute.collection?
                value = attribute.type.cast(attribute.default.call)
                default = attribute.type.as_json(value)
              end

              json_type = json_klass.new(mapping.name, default: default)
            end

            json_type = Collection.new(json_type) if attribute.collection?
            properties << json_type
          end

          objects << Object.new(type.name, properties)
        end

        Schema.new(objects, id: id, title: title, description: description).as_json
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
      #   Shale::Schema::JSONGenerator.new.to_schema(Person)
      #
      # @api public
      def to_schema(klass, id: nil, title: nil, description: nil, pretty: false)
        schema = as_schema(klass, id: id, title: title, description: description)
        options = pretty ? :pretty : nil

        Shale.json_adapter.dump(schema, options)
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
      #
      # @api private
      def collect_composite_types(types, type)
        types << type

        type.json_mapping.keys.values.each do |mapping|
          attribute = type.attributes[mapping.attribute]
          next unless attribute

          if mapper_type?(attribute.type) && !types.include?(attribute.type)
            collect_composite_types(types, attribute.type)
          end
        end
      end
    end
  end
end
