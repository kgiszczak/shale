# frozen_string_literal: true

require_relative '../../shale'
require_relative 'json/schema'
require_relative 'json/boolean'
require_relative 'json/collection'
require_relative 'json/date'
require_relative 'json/float'
require_relative 'json/integer'
require_relative 'json/object'
require_relative 'json/ref'
require_relative 'json/string'
require_relative 'json/time'

module Shale
  module Schema
    # Class for handling JSON schema
    #
    # @api public
    class JSON
      @json_types = Hash.new(Shale::Schema::JSON::String)

      # Register Shale to JSON type mapping
      #
      # @param [Shale::Type::Value] shale_type
      # @param [Shale::Schema::JSON::Base] json_type
      #
      # @example
      #   Shale::Schema::JSON.register_json_type(Shale::Type::String, MyCustomJsonType)
      #
      # @api public
      def self.register_json_type(shale_type, json_type)
        @json_types[shale_type] = json_type
      end

      # Return JSON type for given Shale type
      #
      # @param [Shale::Type::Value] shale_type
      #
      # @return [Shale::Schema::JSON::Base]
      #
      # @example
      #   Shale::Schema::JSON.get_json_type(Shale::Type::String)
      #   # => Shale::Schema::JSON::String
      #
      # @api private
      def self.get_json_type(shale_type)
        @json_types[shale_type]
      end

      register_json_type(Shale::Type::Boolean, Shale::Schema::JSON::Boolean)
      register_json_type(Shale::Type::Date, Shale::Schema::JSON::Date)
      register_json_type(Shale::Type::Float, Shale::Schema::JSON::Float)
      register_json_type(Shale::Type::Integer, Shale::Schema::JSON::Integer)
      register_json_type(Shale::Type::Time, Shale::Schema::JSON::Time)

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
      # @api public
      def as_schema(klass, id: nil, description: nil)
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

        Schema.new(objects, id: id, description: description).as_json
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
      # @api public
      def to_schema(klass, id: nil, description: nil, pretty: false)
        schema = as_schema(klass, id: id, description: description)
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
