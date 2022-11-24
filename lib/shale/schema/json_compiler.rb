# frozen_string_literal: true

require 'erb'
require 'uri'

require_relative '../../shale'
require_relative '../utils'
require_relative 'compiler/boolean'
require_relative 'compiler/complex'
require_relative 'compiler/date'
require_relative 'compiler/float'
require_relative 'compiler/integer'
require_relative 'compiler/property'
require_relative 'compiler/string'
require_relative 'compiler/time'
require_relative 'compiler/value'

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
        require_relative '<%= type.relative_path(property.type.file_name) %>'
        <%- end -%>
        <%- end -%>

        <%- type.modules.each_with_index do |name, i| -%>
        <%= '  ' * i %>module <%= name %>
        <%- end -%>
        <%- indent = '  ' * type.modules.length -%>
        <%= indent %>class <%= type.root_name %> < Shale::Mapper
          <%- type.properties.each do |property| -%>
          <%= indent %>attribute :<%= property.attribute_name %>, <%= property.type.name -%>
          <%- if property.collection? %>, collection: true<% end -%>
          <%- unless property.default.nil? %>, default: -> { <%= property.default %> }<% end %>
          <%- end -%>

          <%= indent %>json do
            <%- type.properties.each do |property| -%>
            <%= indent %>map '<%= property.mapping_name %>', to: :<%= property.attribute_name %>
            <%- end -%>
          <%= indent %>end
        <%= indent %>end
        <%- type.modules.length.times do |i| -%>
        <%= '  ' * (type.modules.length - i - 1) %>end
        <%- end -%>
      TEMPLATE

      # Generate Shale models from JSON Schema and return them as a Ruby Array of objects
      #
      # @param [Array<String>] schemas
      # @param [String, nil] root_name
      # @param [Hash<String, String>, nil] namespace_mapping
      #
      # @raise [SchemaError] when JSON Schema has errors
      #
      # @return [Array<Shale::Schema::Compiler::Complex>]
      #
      # @example
      #   Shale::Schema::JSONCompiler.new.as_models([schema1, schema2])
      #
      # @api public
      def as_models(schemas, root_name: nil, namespace_mapping: nil)
        schemas = schemas.map do |schema|
          Shale.json_adapter.load(schema)
        end

        @root_name = root_name
        @namespace_mapping = namespace_mapping || {}
        @schema_repository = {}
        @types = []

        schemas.each do |schema|
          disassemble_schema(schema)
        end

        compile(schemas[0], true)

        total_duplicates = Hash.new(0)
        duplicates = Hash.new(0)

        @types.each do |type|
          total_duplicates[type.name] += 1
        end

        @types.each do |type|
          duplicates[type.name] += 1

          if total_duplicates[type.name] > 1
            type.root_name = format("#{type.root_name}%d", duplicates[type.name])
          end
        end

        @types.reverse
      end

      # Generate Shale models from JSON Schema
      #
      # @param [Array<String>] schemas
      # @param [String, nil] root_name
      # @param [Hash<String, String>, nil] namespace_mapping
      #
      # @raise [SchemaError] when JSON Schema has errors
      #
      # @return [Hash<String, String>]
      #
      # @example
      #   Shale::Schema::JSONCompiler.new.to_models([schema1, schema2])
      #
      # @api public
      def to_models(schemas, root_name: nil, namespace_mapping: nil)
        types = as_models(schemas, root_name: root_name, namespace_mapping: namespace_mapping)

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
      # @raise [SchemaError] when ref can't be resolved
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
          raise SchemaError, "can't resolve reference '#{key}'"
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
      # @return [Shale::Schema::Compiler::Type]
      #
      # @api private
      def infer_type(schema, id, name)
        return unless schema
        return Compiler::Value.new if schema == true

        type = schema['type']
        format = schema['format']

        if type.is_a?(Array)
          type -= ['null']

          if type.length > 1
            return Compiler::Value.new
          else
            type = type[0]
          end
        end

        if type == 'object'
          base_id = Utils.presence(id.split('#')[0])
          Compiler::Complex.new(id, name, @namespace_mapping[base_id])
        elsif type == 'string' && format == 'date'
          Compiler::Date.new
        elsif type == 'string' && format == 'date-time'
          Compiler::Time.new
        elsif type == 'string'
          Compiler::String.new
        elsif type == 'number'
          Compiler::Float.new
        elsif type == 'integer'
          Compiler::Integer.new
        elsif type == 'boolean'
          Compiler::Boolean.new
        else
          Compiler::Value.new
        end
      end

      # Disassemble JSON schema into separate subschemas
      #
      # @param [String] schema
      # @param [Array<String>] fragment
      # @param [String] base_id
      #
      # @raise [SchemaError] when there are problems with JSON schema
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
          raise SchemaError, "schema with id '#{pointer}' already exists"
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
      # @return [Shale::Schema::Compiler::Property, nil]
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
          entry_id, entry_fragment = entry[:id].split('#')
          id = build_id(id, entry_id)
          fragment = (entry_fragment || '').split('/') - ['']
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

        if type.is_a?(Compiler::Complex) && !@types.include?(type)
          @types << type

          (schema['properties'] || {}).each do |subschema_key, subschema|
            property = compile(subschema, false, id, [*fragment, 'properties', subschema_key])
            type.add_property(property) if property
          end
        end

        Compiler::Property.new(key, type, collection, default) if type
      end
    end
  end
end
