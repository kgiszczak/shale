# frozen_string_literal: true

require_relative 'base'
require_relative 'xml_descriptor'
require_relative 'xml_namespace'

module Shale
  module Mapping
    class Xml < Base
      # default value for not defined namespace
      UNDEFINED = :undefined

      # Return elements mapping hash
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :elements

      # Return attributes mapping hash
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :attributes

      # Return content mapping
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :content

      # Return default namespace
      #
      # @return [Shale::Mapping::XmlNamespace]
      #
      # @api private
      attr_reader :default_namespace

      # Return prefixed root
      #
      # @return [String]
      #
      # @api private
      def prefixed_root
        [default_namespace.prefix, @root].compact.join(':')
      end

      # Initialize instance
      #
      # @api private
      def initialize
        super
        @elements = {}
        @attributes = {}
        @content = nil
        @root = ''
        @default_namespace = XmlNamespace.new
      end

      # Map element to attribute
      #
      # @param [String] element Document's element
      # @param [Symbol, nil] to Object's attribute
      # @param [Hash, nil] using
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map_element(element, to: nil, using: nil, namespace: UNDEFINED, prefix: UNDEFINED)
        validate_arguments(element, to, using)
        validate_namespace(element, namespace, prefix)

        if namespace == UNDEFINED && prefix == UNDEFINED
          nsp = default_namespace.name
          pfx = default_namespace.prefix
        else
          nsp = namespace
          pfx = prefix
        end

        namespaced_element = [nsp, element].compact.join(':')

        @elements[namespaced_element] = XmlDescriptor.new(
          name: element,
          attribute: to,
          methods: using,
          namespace: XmlNamespace.new(nsp, pfx)
        )
      end

      # Map document's attribute to object's attribute
      #
      # @param [String] attribute Document's attribute
      # @param [Symbol, nil] to Object's attribute
      # @param [Hash, nil] using
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map_attribute(attribute, to: nil, using: nil, namespace: nil, prefix: nil)
        validate_arguments(attribute, to, using)
        validate_namespace(attribute, namespace, prefix)

        namespaced_attribute = [namespace, attribute].compact.join(':')

        @attributes[namespaced_attribute] = XmlDescriptor.new(
          name: attribute,
          attribute: to,
          methods: using,
          namespace: XmlNamespace.new(namespace, prefix)
        )
      end

      # Map document's content to object's attribute
      #
      # @param [Symbol] to Object's attribute
      #
      # @api private
      def map_content(to:)
        @content = to
      end

      # Set the name for root element
      #
      # @param [String] value root's name
      #
      # @api private
      def root(value)
        @root = value
      end

      # Set default namespace for root element
      #
      # @param [String] name
      # @param [String] prefix
      #
      # @api private
      def namespace(name, prefix)
        @default_namespace.name = name
        @default_namespace.prefix = prefix
      end

      # @api private
      def initialize_dup(other)
        @elements = other.instance_variable_get('@elements').dup
        @attributes = other.instance_variable_get('@attributes').dup
        @content = other.instance_variable_get('@content').dup
        @root = other.instance_variable_get('@root').dup
        @default_namespace = other.instance_variable_get('@default_namespace').dup

        super
      end

      private

      # Validate correctness of namespace arguments
      #
      # @param [String] key
      # @param [String, Symbol, nil] namespace
      # @param [String, Symbol, nil] prefix
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def validate_namespace(key, namespace, prefix)
        return if namespace == UNDEFINED && prefix == UNDEFINED

        nsp = namespace == UNDEFINED ? nil : namespace
        pfx = prefix == UNDEFINED ? nil : prefix

        if (nsp && !pfx) || (!nsp && pfx)
          msg = "both :namespace and :prefix arguments are required for mapping '#{key}'"
          raise IncorrectMappingArgumentsError, msg
        end
      end
    end
  end
end
