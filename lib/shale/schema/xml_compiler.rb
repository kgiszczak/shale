# frozen_string_literal: true

require 'erb'

require_relative '../../shale'
require_relative '../error'
require_relative 'compiler/boolean'
require_relative 'compiler/date'
require_relative 'compiler/float'
require_relative 'compiler/integer'
require_relative 'compiler/string'
require_relative 'compiler/time'
require_relative 'compiler/value'
require_relative 'compiler/xml_complex'
require_relative 'compiler/xml_property'

module Shale
  module Schema
    # Class for compiling XML schema into Ruby data model
    #
    # @api public
    class XMLCompiler
      # XML namespace URI
      # @api private
      XML_NAMESPACE_URI = 'http://www.w3.org/XML/1998/namespace'

      # XML namespace prefix
      # @api private
      XML_NAMESPACE_PREFIX = 'xml'

      # XML Schema namespace URI
      # @api private
      XS_NAMESPACE_URI = 'http://www.w3.org/2001/XMLSchema'

      # XML Schema "schema" element name
      # @api private
      XS_SCHEMA = "#{XS_NAMESPACE_URI}:schema"

      # XML Schema "element" element name
      # @api private
      XS_ELEMENT = "#{XS_NAMESPACE_URI}:element"

      # XML Schema "attribute" element name
      # @api private
      XS_ATTRIBUTE = "#{XS_NAMESPACE_URI}:attribute"

      # XML Schema "attribute" element name
      # @api private
      XS_SIMPLE_TYPE = "#{XS_NAMESPACE_URI}:simpleType"

      # XML Schema "simpleContent" element name
      # @api private
      XS_SIMPLE_CONTENT = "#{XS_NAMESPACE_URI}:simpleContent"

      # XML Schema "restriction" element name
      # @api private
      XS_RESTRICTION = "#{XS_NAMESPACE_URI}:restriction"

      # XML Schema "group" element name
      # @api private
      XS_GROUP = "#{XS_NAMESPACE_URI}:group"

      # XML Schema "attributeGroup" element name
      # @api private
      XS_ATTRIBUTE_GROUP = "#{XS_NAMESPACE_URI}:attributeGroup"

      # XML Schema "complexType" element name
      # @api private
      XS_COMPLEX_TYPE = "#{XS_NAMESPACE_URI}:complexType"

      # XML Schema "complexContent" element name
      # @api private
      XS_COMPLEX_CONTENT = "#{XS_NAMESPACE_URI}:complexContent"

      # XML Schema "extension" element name
      # @api private
      XS_EXTENSION = "#{XS_NAMESPACE_URI}:extension"

      # XML Schema "anyType" type
      # @api private
      XS_TYPE_ANY = "#{XS_NAMESPACE_URI}:anyType"

      # XML Schema "date" types
      # @api private
      XS_TYPE_DATE = [
        "#{XS_NAMESPACE_URI}:date",
      ].freeze

      # XML Schema "datetime" types
      # @api private
      XS_TYPE_TIME = [
        "#{XS_NAMESPACE_URI}:dateTime",
      ].freeze

      # XML Schema "string" types
      # @api private
      XS_TYPE_STRING = [
        "#{XS_NAMESPACE_URI}:string",
        "#{XS_NAMESPACE_URI}:normalizedString",
        "#{XS_NAMESPACE_URI}:token",
      ].freeze

      # XML Schema "float" types
      # @api private
      XS_TYPE_FLOAT = [
        "#{XS_NAMESPACE_URI}:decimal",
        "#{XS_NAMESPACE_URI}:float",
        "#{XS_NAMESPACE_URI}:double",
      ].freeze

      # XML Schema "integer" types
      # @api private
      XS_TYPE_INTEGER = [
        "#{XS_NAMESPACE_URI}:integer",
        "#{XS_NAMESPACE_URI}:byte",
        "#{XS_NAMESPACE_URI}:int",
        "#{XS_NAMESPACE_URI}:long",
        "#{XS_NAMESPACE_URI}:negativeInteger",
        "#{XS_NAMESPACE_URI}:nonNegativeInteger",
        "#{XS_NAMESPACE_URI}:nonPositiveInteger",
        "#{XS_NAMESPACE_URI}:positiveInteger",
        "#{XS_NAMESPACE_URI}:short",
        "#{XS_NAMESPACE_URI}:unsignedLong",
        "#{XS_NAMESPACE_URI}:unsignedInt",
        "#{XS_NAMESPACE_URI}:unsignedShort",
        "#{XS_NAMESPACE_URI}:unsignedByte",
      ].freeze

      # XML Schema "boolean" types
      # @api private
      XS_TYPE_BOOLEAN = [
        "#{XS_NAMESPACE_URI}:boolean",
      ].freeze

      # Shale model template
      # @api private
      MODEL_TEMPLATE = ERB.new(<<~TEMPLATE, trim_mode: '-')
        require 'shale'
        <%- unless type.references.empty? -%>

        <%- type.references.each do |property| -%>
        require_relative '<%= property.type.file_name %>'
        <%- end -%>
        <%- end -%>

        class <%= type.ruby_class_name %> < Shale::Mapper
          <%- type.properties.select(&:content?).each do |property| -%>
          attribute :<%= property.attribute_name %>, <%= property.type.ruby_class_name -%>
          <%- if property.collection? %>, collection: true<% end -%>
          <%- unless property.default.nil? %>, default: -> { <%= property.default %> }<% end %>
          <%- end -%>
          <%- type.properties.select(&:attribute?).each do |property| -%>
          attribute :<%= property.attribute_name %>, <%= property.type.ruby_class_name -%>
          <%- if property.collection? %>, collection: true<% end -%>
          <%- unless property.default.nil? %>, default: -> { <%= property.default %> }<% end %>
          <%- end -%>
          <%- type.properties.select(&:element?).each do |property| -%>
          attribute :<%= property.attribute_name %>, <%= property.type.ruby_class_name -%>
          <%- if property.collection? %>, collection: true<% end -%>
          <%- unless property.default.nil? %>, default: -> { <%= property.default %> }<% end %>
          <%- end -%>

          xml do
            root '<%= type.root %>'
            <%- if type.namespace -%>
            namespace '<%= type.namespace %>', '<%= type.prefix %>'
            <%- end -%>
            <%- unless type.properties.empty? -%>

            <%- type.properties.select(&:content?).each do |property| -%>
            map_content to: :<%= property.attribute_name %>
            <%- end -%>
            <%- type.properties.select(&:attribute?).each do |property| -%>
            map_attribute '<%= property.mapping_name %>', to: :<%= property.attribute_name -%>
            <%- if property.namespace %>, prefix: '<%= property.prefix %>'<%- end -%>
            <%- if property.namespace %>, namespace: '<%= property.namespace %>'<% end %>
            <%- end -%>
            <%- type.properties.select(&:element?).each do |property| -%>
            map_element '<%= property.mapping_name %>', to: :<%= property.attribute_name -%>
            <%- if type.namespace != property.namespace %>, prefix: <%= property.prefix ? "'\#{property.prefix}'" : 'nil' %><%- end -%>
            <%- if type.namespace != property.namespace %>, namespace: <%= property.namespace ? "'\#{property.namespace}'" : 'nil' %><% end %>
            <%- end -%>
            <%- end -%>
          end
        end
      TEMPLATE

      # Generate Shale models from XML Schema and return them as a Ruby Array of objects
      #
      # @param [Array<String>] schemas
      #
      # @raise [AdapterError] when XML adapter is not set or Ox adapter is used
      # @raise [SchemaError] when XML Schema has errors
      #
      # @return [Array<Shale::Schema::Compiler::XMLComplex>]
      #
      # @example
      #   Shale::Schema::XMLCompiler.new.as_models([schema1, schema2])
      #
      # @api public
      def as_models(schemas)
        unless Shale.xml_adapter
          raise AdapterError, XML_ADAPTER_NOT_SET_MESSAGE
        end

        if Shale.xml_adapter.name == 'Shale::Adapter::Ox'
          msg = "Ox doesn't support XML namespaces and can't be used to compile XML Schema"
          raise AdapterError, msg
        end

        schemas = schemas.map do |schema|
          Shale.xml_adapter.load(schema)
        end

        @elements_repository = {}
        @attributes_repository = {}
        @simple_types_repository = {}
        @element_groups_repository = {}
        @attribute_groups_repository = {}
        @complex_types_repository = {}
        @complex_types = {}
        @types = []

        schemas.each do |schema|
          build_repositories(schema)
        end

        resolve_nested_refs(@simple_types_repository)

        schemas.each do |schema|
          compile(schema)
        end

        @types = @types.uniq

        total_duplicates = Hash.new(0)
        duplicates = Hash.new(0)

        @types.each do |type|
          total_duplicates[type.name] += 1
        end

        @types.each do |type|
          duplicates[type.name] += 1

          if total_duplicates[type.name] > 1
            type.name = format("#{type.name}%d", duplicates[type.name])
          end
        end

        @types.reverse
      rescue ParseError => e
        raise SchemaError, "XML Schema document is invalid: #{e.message}"
      end

      # Generate Shale models from XML Schema
      #
      # @param [Array<String>] schemas
      # @param [<String>] namespace
      #
      # @raise [SchemaError] when XML Schema has errors
      #
      # @return [Hash<String, String>]
      #
      # @example
      #   Shale::Schema::XMLCompiler.new.to_models([schema1, schema2])
      #
      # @api public
      def to_models(schemas, ruby_namespace: nil)
        @ruby_namespace = ruby_namespace

        types = as_models(schemas)

        types.to_h do |type|
          [type.file_name, MODEL_TEMPLATE.result(binding)]
        end
      end

      private

      # Check if node is a given type
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      # @param [String] name
      #
      # @return [true false]
      #
      # @api private
      def node_is_a?(node, name)
        node.name == name
      end

      # Check if node has attribute
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      # @param [String] name
      #
      # @return [true false]
      #
      # @api private
      # rubocop:disable Naming/PredicateName
      def has_attribute?(node, name)
        node.attributes.key?(name)
      end
      # rubocop:enable Naming/PredicateName

      # Traverse over all child nodes and call a block for each one
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @yieldparam [Shale::Adapter::<Adapter>::Node]
      #
      # @api private
      def traverse(node, &block)
        node.children.each do |child|
          block.call(child)
          traverse(child, &block)
        end
      end

      # Return XML namespaces
      #
      # @param [String] schema
      #
      # @return [Hash<String, String>]
      #
      # @api private
      def get_namespaces(schema)
        schema.namespaces.merge(XML_NAMESPACE_PREFIX => XML_NAMESPACE_URI)
      end

      # Get schema node
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [Shale::Adapter::<Adapter>::Node, nil]
      #
      # @api private
      def get_schema(node)
        el = node

        while el
          return el if node_is_a?(el, XS_SCHEMA)
          el = el.parent
        end
      end

      # Join parts with ":"
      #
      # @param [String] name
      # @param [String] namespace
      #
      # @return [String]
      #
      # @api private
      def join_id_parts(name, namespace)
        [namespace, name].compact.join(':')
      end

      # Build id from name
      #
      # @param [String] name
      # @param [String] namespace
      #
      # @return [String]
      #
      # @api private
      def build_id_from_name(name, namespace)
        join_id_parts(name, namespace)
      end

      # Build id from child nodes
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      # @param [String] namespace
      #
      # @return [String]
      #
      # @api private
      def build_id_from_parents(node, namespace)
        parts = [node.attributes['name']]

        while (node = node.parent)
          parts << node.attributes['name']
        end

        join_id_parts(namespace, parts.compact.reverse.join('/'))
      end

      # Build unique id for a node
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [String]
      #
      # @api private
      def build_id(node)
        name = node.attributes['name']
        namespace = get_schema(node).attributes['targetNamespace']

        if name
          build_id_from_name(name, namespace)
        else
          build_id_from_parents(node, namespace)
        end
      end

      # Replace namespace prefixes with URIs
      #
      # @param [String] type
      # @param [Hash<String, String>] namespaces
      #
      # @return [String]
      #
      # @api private
      def replace_ns_prefixes(type, namespaces)
        namespaces.each do |prefix, name|
          type = type.sub(/^#{prefix}/, name)
        end

        type
      end

      # Normalize reference to type
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [String]
      #
      # @api private
      def normalize_type_ref(node)
        schema = get_schema(node)
        type = node.attributes['type']

        if type
          replace_ns_prefixes(type, get_namespaces(schema))
        else
          build_id_from_parents(node, schema.attributes['targetNamespace'])
        end
      end

      # Infer simple type from node
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [String]
      #
      # @api private
      def infer_simple_type(node)
        type = XS_TYPE_ANY
        namespaces = get_namespaces(get_schema(node))

        traverse(node) do |child|
          if node_is_a?(child, XS_RESTRICTION) && has_attribute?(child, 'base')
            type = replace_ns_prefixes(child.attributes['base'], namespaces)
          end
        end

        type
      end

      def resolve_ref(repository, ref)
        target = repository[ref]

        raise SchemaError, "Can't resolve reference/type: #{ref}" unless target

        target
      end

      # Resolve namespace for complex type
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [Array<String>]
      #
      # @api private
      def resolve_complex_type_namespace(node)
        schema = get_schema(node)
        namespaces = get_namespaces(schema)
        target_namespace = schema.attributes['targetNamespace']
        form_default = schema.attributes['elementFormDefault']
        form_element = node.parent.attributes['form'] || form_default

        is_top = node_is_a?(node.parent, XS_SCHEMA)
        parent_is_top = node.parent.parent && node_is_a?(node.parent.parent, XS_SCHEMA)
        parent_is_qualified = form_element == 'qualified'

        if is_top || parent_is_top || parent_is_qualified
          [namespaces.key(target_namespace), target_namespace]
        end
      end

      # Resolve namespace for properties
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      # @param [String] form_default
      #
      # @return [Array<String>]
      #
      # @api private
      def resolve_namespace(node, form_default)
        schema = get_schema(node)
        namespaces = get_namespaces(schema)
        target_namespace = schema.attributes['targetNamespace']
        form_default = schema.attributes[form_default]
        form_element = node.attributes['form'] || form_default

        is_top = node_is_a?(node.parent, XS_SCHEMA)
        is_qualified = form_element == 'qualified'

        if is_top || is_qualified
          [namespaces.key(target_namespace), target_namespace]
        end
      end

      # Build repository of XML Schema entities
      #
      # @param [Shale::Adapter::<Adapter>::Node] schema
      #
      # @api private
      def build_repositories(schema)
        traverse(schema) do |node|
          id = build_id(node)

          if node_is_a?(node, XS_ELEMENT) && has_attribute?(node, 'name')
            @elements_repository[id] = node
          elsif node_is_a?(node, XS_ATTRIBUTE) && has_attribute?(node, 'name')
            @attributes_repository[id] = node
          elsif node_is_a?(node, XS_SIMPLE_TYPE)
            @simple_types_repository[id] = infer_simple_type(node)
          elsif node_is_a?(node, XS_GROUP) && has_attribute?(node, 'name')
            @element_groups_repository[id] = node
          elsif node_is_a?(node, XS_ATTRIBUTE_GROUP) && has_attribute?(node, 'name')
            @attribute_groups_repository[id] = node
          elsif node_is_a?(node, XS_COMPLEX_TYPE)
            @complex_types_repository[id] = node

            name = node.attributes['name'] || node.parent.attributes['name']
            prefix, namespace = resolve_complex_type_namespace(node)

            @complex_types[id] = Compiler::XMLComplex.new(id, name, prefix, namespace, @ruby_namespace)
          end
        end
      end

      # Resolve nested references
      #
      # @param [Hash<String, String>] repo
      #
      # @api private
      def resolve_nested_refs(repo)
        unresolved = repo.values & repo.keys

        until unresolved.empty?
          unresolved.each do |ref|
            key = repo.key(ref)
            repo[key] = repo[ref]
          end

          unresolved = repo.values & repo.keys
        end
      end

      # Infer type from node
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [Shale::Schema::Compiler::<any>]
      #
      # @api private
      def infer_type(node)
        namespaces = get_namespaces(get_schema(node))
        type = normalize_type_ref(node)
        infer_type_from_xs_type(type, namespaces)
      end

      def infer_type_from_xs_type(type, namespaces)
        type = replace_ns_prefixes(type, namespaces)

        return @complex_types[type] if @complex_types[type]

        type = @simple_types_repository[type] if @simple_types_repository[type]

        if XS_TYPE_DATE.include?(type)
          Compiler::Date.new
        elsif XS_TYPE_TIME.include?(type)
          Compiler::Time.new
        elsif XS_TYPE_STRING.include?(type)
          Compiler::String.new
        elsif XS_TYPE_FLOAT.include?(type)
          Compiler::Float.new
        elsif XS_TYPE_INTEGER.include?(type)
          Compiler::Integer.new
        elsif XS_TYPE_BOOLEAN.include?(type)
          Compiler::Boolean.new
        else
          Compiler::Value.new
        end
      end

      # Test if element is a collection
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      # @param [String] max_occurs
      #
      # @return [true, false]
      #
      # @api private
      def infer_collection(node, max_occurs)
        max = node.parent.attributes['maxOccurs'] || max_occurs || '1'

        if has_attribute?(node, 'maxOccurs')
          max = node.attributes['maxOccurs'] || '1'
        end

        max == 'unbounded' || max.to_i > 1
      end

      # Return base type ref
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [String]
      #
      # @api private
      def find_extension(node)
        complex_content = node.children.find { |e| node_is_a?(e, XS_COMPLEX_CONTENT) }
        return nil unless complex_content

        child = complex_content.children.find do |ch|
          node_is_a?(ch, XS_EXTENSION)
        end

        if child && has_attribute?(child, 'base')
          namespaces = get_namespaces(get_schema(node))
          replace_ns_prefixes(child.attributes['base'], namespaces)
        end
      end

      # Return base type ref
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [String]
      #
      # @api private
      def find_restriction(node)
        complex_content = node.children.find { |e| node_is_a?(e, XS_COMPLEX_CONTENT) }
        return nil unless complex_content

        child = complex_content.children.find do |ch|
          node_is_a?(ch, XS_RESTRICTION)
        end

        if child && has_attribute?(child, 'base')
          namespaces = get_namespaces(get_schema(node))
          replace_ns_prefixes(child.attributes['base'], namespaces)
        end
      end

      # Return content type
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [String]
      #
      # @api private
      def find_content(node)
        return "#{XS_NAMESPACE_URI}:string" if node.attributes['mixed'] == 'true'

        type = nil

        node.children.each do |child|
          if node_is_a?(child, XS_SIMPLE_CONTENT)
            child.children.each do |ch|
              if ch.attributes['base']
                type = ch.attributes['base']
              end
            end
          elsif node_is_a?(child, XS_COMPLEX_CONTENT) && child.attributes['mixed'] == 'true'
            type = "#{XS_NAMESPACE_URI}:string"
          end

          break if type
        end

        type
      end

      # Return attributes
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [Array<Shale::Adapter::<Adapter>::Node>]
      #
      # @api private
      def find_attributes(node)
        found = []

        namespaces = get_namespaces(get_schema(node))

        node.children.each do |child|
          if node_is_a?(child, XS_ATTRIBUTE) && has_attribute?(child, 'ref')
            ref = replace_ns_prefixes(child.attributes['ref'], namespaces)
            found << resolve_ref(@attributes_repository, ref)
          elsif node_is_a?(child, XS_ATTRIBUTE) && has_attribute?(child, 'name')
            found << child
          elsif node_is_a?(child, XS_ATTRIBUTE_GROUP) && has_attribute?(child, 'ref')
            ref = replace_ns_prefixes(child.attributes['ref'], namespaces)
            group = resolve_ref(@attribute_groups_repository, ref)
            found += find_attributes(group)
          elsif !node_is_a?(child, XS_ELEMENT)
            found += find_attributes(child)
          end
        end

        found
      end

      # Return elements
      #
      # @param [Shale::Adapter::<Adapter>::Node] node
      #
      # @return [Hash]
      #
      # @api private
      def find_elements(node)
        found = []

        namespaces = get_namespaces(get_schema(node))

        node.children.each do |child|
          if node_is_a?(child, XS_ELEMENT) && has_attribute?(child, 'ref')
            max_occurs = nil

            if has_attribute?(child.parent, 'maxOccurs')
              max_occurs = child.parent.attributes['maxOccurs']
            end

            if has_attribute?(child, 'maxOccurs')
              max_occurs = child.attributes['maxOccurs']
            end

            ref = replace_ns_prefixes(child.attributes['ref'], namespaces)
            found << { element: resolve_ref(@elements_repository, ref), max_occurs: max_occurs }
          elsif node_is_a?(child, XS_ELEMENT) && has_attribute?(child, 'name')
            found << { element: child }
          elsif node_is_a?(child, XS_GROUP) && has_attribute?(child, 'ref')
            ref = replace_ns_prefixes(child.attributes['ref'], namespaces)
            group = resolve_ref(@element_groups_repository, ref)
            group_elements = find_elements(group)

            max_occurs = nil

            if has_attribute?(child.parent, 'maxOccurs')
              max_occurs = child.parent.attributes['maxOccurs']
            end

            if has_attribute?(child, 'maxOccurs')
              max_occurs = child.attributes['maxOccurs']
            end

            if max_occurs
              group_elements.each do |data|
                el = data[:element]

                unless el.attributes.key?('maxOccurs')
                  data[:max_occurs] = max_occurs
                end
              end
            end

            found += group_elements
          else
            found += find_elements(child)
          end
        end

        found
      end

      # Compile complex type
      #
      # @param [Shale::Schema::Compiler::XMLComplex] complex_type
      # @param [Shale::Adapter::<Adapter>::Node] node
      # @param [Symbol] mode
      #
      # @api private
      def compile_complex_type(complex_type, node, mode: :standard)
        extension = find_extension(node)
        restriction = find_restriction(node)

        if extension
          base_node = resolve_ref(@complex_types_repository, extension)
          compile_complex_type(complex_type, base_node)
        end

        if restriction
          base_node = resolve_ref(@complex_types_repository, restriction)
          compile_complex_type(complex_type, base_node, mode: :restriction)
        end

        if mode == :standard
          content_type = find_content(node)

          if content_type
            namespaces = get_namespaces(get_schema(node))
            type = infer_type_from_xs_type(content_type, namespaces)

            property = Compiler::XMLProperty.new(
              name: 'content',
              type: type,
              collection: false,
              default: nil,
              prefix: nil,
              namespace: nil,
              category: :content
            )

            complex_type.add_property(property)
          end
        end

        elements = find_attributes(node)

        elements.each do |element|
          name = element.attributes['name']
          type = infer_type(element)
          default = element.attributes['default']
          prefix, namespace = resolve_namespace(element, 'attributeFormDefault')

          property = Compiler::XMLProperty.new(
            name: name,
            type: type,
            collection: false,
            default: default,
            prefix: prefix,
            namespace: namespace,
            category: :attribute
          )

          complex_type.add_property(property)
        end

        if mode == :standard
          elements = find_elements(node)

          elements.each do |data|
            element = data[:element]
            name = element.attributes['name']
            type = infer_type(element)
            collection = infer_collection(element, data[:max_occurs])
            default = element.attributes['default']
            prefix, namespace = resolve_namespace(element, 'elementFormDefault')

            property = Compiler::XMLProperty.new(
              name: name,
              type: type,
              collection: collection,
              default: default,
              prefix: prefix,
              namespace: namespace,
              category: :element
            )

            complex_type.add_property(property)
          end
        end
      end

      # Return top level elements
      #
      # @param [Shale::Adapter::<Adapter>::Node] schema
      #
      # @return [Shale::Adapter::<Adapter>::Node]
      #
      # @api private
      def find_top_level_elements(schema)
        schema.children.select { |child| node_is_a?(child, XS_ELEMENT) }
      end

      # Collect active types
      #
      # @param [Shale::Schema::Compiler::<any>] type
      #
      # @api private
      def collect_active_types(type)
        return if @types.include?(type)
        return unless type.is_a?(Compiler::XMLComplex)

        @types << type

        type.properties.each do |property|
          collect_active_types(property.type)
        end
      end

      # Compile schema
      #
      # @param [Shale::Adapter::<Adapter>::Node] schema
      #
      # @api private
      def compile(schema)
        @complex_types_repository.each do |id, node|
          complex_type = resolve_ref(@complex_types, id)
          compile_complex_type(complex_type, node)
        end

        elements = find_top_level_elements(schema)

        elements.each do |element|
          type = @complex_types[normalize_type_ref(element)]

          next unless type

          type.root = element.attributes['name']
          collect_active_types(type)
        end
      end
    end
  end
end
