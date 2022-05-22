# frozen_string_literal: true

require 'erb'
require 'uri'

require_relative '../../shale'
require_relative 'json_compiler/boolean'
require_relative 'json_compiler/date'
require_relative 'json_compiler/float'
require_relative 'json_compiler/integer'
require_relative 'json_compiler/object'
require_relative 'json_compiler/property'
require_relative 'json_compiler/string'
require_relative 'json_compiler/time'
require_relative 'json_compiler/value'

module Shale
  module Schema
    # Class for compiling JSON schema into Ruby data model
    #
    # @api public
    class JSONCompiler
      # Default root type name
      # @api private
      DEFAULT_ROOT_NAME = 'root'

      # Shale model template
      # @api private
      MODEL_TEMPLATE = ERB.new(<<~TEMPLATE, trim_mode: '-')
        require 'shale'
        <%- unless type.references.empty? -%>

        <%- type.references.each do |property| -%>
        require_relative '<%= property.type.file_name %>'
        <%- end -%>
        <%- end -%>

        class <%= type.name %> < Shale::Mapper
          <%- type.properties.each do |property| -%>
          attribute :<%= property.attribute_name %>, <%= property.type.name -%>
          <%- if property.collection? %>, collection: true<% end -%>
          <%- unless property.default.nil? %>, default: -> { <%= property.default %> }<% end %>
          <%- end -%>

          json do
            <%- type.properties.each do |property| -%>
            map '<%= property.property_name %>', to: :<%= property.attribute_name %>
            <%- end -%>
          end
        end
      TEMPLATE

      # Generate Shale models from JSON Schema and return them as a Ruby Array od objects
      #
      # @param [Array<String>] schemas
      # @param [String, nil] root_name
      #
      # @raise [JSONSchemaError] when JSON Schema has errors
      #
      # @return [Array<Shale::Schema::JSONCompiler::Object>]
      #
      # @example
      #   Shale::Schema::JSONCompiler.new.as_models([schema1, schema2])
      #
      # @api public
      def as_models(schemas, root_name: nil)
        schemas = schemas.map do |schema|
          Shale.json_adapter.load(schema)
        end

        @root_name = root_name
        @schema_repository = {}
        @types = []

        schemas.each do |schema|
          disassemble_schema(schema)
        end

        compile(schemas[0], true)

        total_duplicates = Hash.new(0)
        duplicates = Hash.new(0)

        # rubocop:disable Style/CombinableLoops
        @types.each do |type|
          total_duplicates[type.name] += 1
        end

        @types.each do |type|
          duplicates[type.name] += 1

          if total_duplicates[type.name] > 1
            type.name = format("#{type.name}%d", duplicates[type.name])
          end
        end
        # rubocop:enable Style/CombinableLoops

        @types.reverse
      end

      # Generate Shale models from JSON Schema
      #
      # @param [Array<String>] schemas
      # @param [String, nil] root_name
      #
      # @raise [JSONSchemaError] when JSON Schema has errors
      #
      # @return [Hash<String, String>]
      #
      # @example
      #   Shale::Schema::JSONCompiler.new.to_models([schema1, schema2])
      #
      # @api public
      def to_models(schemas, root_name: nil)
        types = as_models(schemas, root_name: root_name)

        types.to_h do |type|
          [type.file_name, MODEL_TEMPLATE.result(binding)]
        end
      end

      private

      # Generate JSON Schema id
      #
      # @param [String, nil] base_id
      # @param [String, nil] id
      #
      # @return [String]
      #
      # @api private
      def build_id(base_id, id)
        return base_id unless id

        base_uri = URI(base_id || '')
        uri = URI(id)

        if base_uri.relative? && uri.relative?
          uri.to_s
        else
          base_uri.merge(uri).to_s
        end
      end

      # Generate JSON pointer
      #
      # @param [String, nil] id
      # @param [Array<String>] fragment
      #
      # @return [String]
      #
      # @api private
      def build_pointer(id, fragment)
        ([id, ['#', *fragment].join('/')] - ['#']).join
      end

      # Resolve JSON Schem ref
      #
      # @param [String, nil] base_id
      # @param [String, nil] ref
      #
      # @raise [JSONSchemaError] when ref can't be resolved
      #
      # @return [Hash, true, false]
      #
      # @api private
      def resolve_ref(base_id, ref)
        ref_id, fragment = (ref || '').split('#')
        id = build_id(base_id, ref_id == '' ? nil : ref_id)
        key = [id, fragment].compact.join('#')

        entry = @schema_repository[key]

        unless entry
          raise JSONSchemaError, "can't resolve reference '#{key}'"
        end

        if entry[:schema].key?('$ref')
          resolve_ref(id, entry[:schema]['$ref'])
        else
          entry
        end
      end

      # Get Shale type from JSON Schema type
      #
      # @param [Hash, true, false, nil] schema
      # @param [String] id
      # @param [String] name
      #
      # @return [Shale::Schema::JSONCompiler::Type]
      #
      # @api private
      def infer_type(schema, id, name)
        return unless schema
        return Value.new if schema == true

        type = schema['type']
        format = schema['format']

        if type.is_a?(Array)
          type -= ['null']

          if type.length > 1
            return Value.new
          else
            type = type[0]
          end
        end

        if type == 'object'
          Object.new(id, name)
        elsif type == 'string' && format == 'date'
          Date.new
        elsif type == 'string' && format == 'date-time'
          Time.new
        elsif type == 'string'
          String.new
        elsif type == 'number'
          Float.new
        elsif type == 'integer'
          Integer.new
        elsif type == 'boolean'
          Boolean.new
        else
          Value.new
        end
      end

      # Disassemble JSON schema into separate subschemas
      #
      # @param [String] schema
      # @param [Array<String>] fragment
      # @param [String] base_id
      #
      # @raise [JSONSchemaError] when there are problems with JSON schema
      #
      # @api private
      def disassemble_schema(schema, fragment = [], base_id = '')
        schema_key = fragment[-1]

        if schema.is_a?(Hash) && schema.key?('$id')
          id = build_id(base_id, schema['$id'])
          fragment = []
        else
          id = base_id
        end

        pointer = build_pointer(id, fragment)

        if @schema_repository.key?(pointer)
          raise JSONSchemaError, "schema with id '#{pointer}' already exists"
        else
          @schema_repository[pointer] = {
            id: pointer,
            key: schema_key,
            schema: schema,
          }
        end

        return unless schema.is_a?(Hash)

        ['properties', '$defs'].each do |definitions|
          (schema[definitions] || {}).each do |subschema_key, subschema|
            disassemble_schema(subschema, [*fragment, definitions, subschema_key], id)
          end
        end
      end

      # Compile JSON schema into Shale types
      #
      # @param [String] schema
      # @param [true, false] is_root
      # @param [String] base_id
      # @param [Array<String>] fragment
      #
      # @return [Shale::Schema::JSONCompiler::Property, nil]
      #
      # @api private
      def compile(schema, is_root, base_id = '', fragment = [])
        entry = {}
        key = fragment[-1]
        collection = false
        default = nil

        if schema.is_a?(Hash) && schema.key?('$id')
          id = build_id(base_id, schema['$id'])
          fragment = []
        else
          id = base_id
        end

        if schema.is_a?(Hash) && schema['type'] == 'array'
          collection = true
          schema = schema['items']
          schema ||= true
        end

        if schema.is_a?(Hash) && schema.key?('$ref')
          entry = resolve_ref(id, schema['$ref'])
          schema = entry[:schema]
          fragment = entry[:id].split('/') - ['#']
        end

        pointer = entry[:id] || build_pointer(id, fragment)

        if is_root
          name = @root_name || entry[:key] || key || DEFAULT_ROOT_NAME
        else
          name = entry[:key] || key
        end

        type = @types.find { |e| e.id == pointer }
        type ||= infer_type(schema, pointer, name)

        if schema.is_a?(Hash) && schema.key?('default')
          default = schema['default']
        end

        if type.is_a?(Object) && !@types.include?(type)
          @types << type

          (schema['properties'] || {}).each do |subschema_key, subschema|
            property = compile(subschema, false, id, [*fragment, 'properties', subschema_key])
            type.add_property(property) if property
          end
        end

        Property.new(key, type, collection, default) if type
      end
    end
  end
end
