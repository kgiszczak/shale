# frozen_string_literal: true

require_relative 'descriptor/xml'
require_relative 'descriptor/xml_namespace'
require_relative 'validator'

module Shale
  module Mapping
    class Xml
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
      # @return [Shale::Mapping::Descriptor::XmlNamespace]
      #
      # @api private
      attr_reader :default_namespace

      # Return unprefixed root
      #
      # @return [String]
      #
      # @api private
      def unprefixed_root
        @root
      end

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
        @default_namespace = Descriptor::XmlNamespace.new
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
      def map_element(element, to: nil, using: nil, namespace: :undefined, prefix: :undefined)
        Validator.validate_arguments(element, to, using)
        Validator.validate_namespace(element, namespace, prefix)

        if namespace == :undefined && prefix == :undefined
          nsp = default_namespace.name
          pfx = default_namespace.prefix
        else
          nsp = namespace
          pfx = prefix
        end

        namespaced_element = [nsp, element].compact.join(':')

        @elements[namespaced_element] = Descriptor::Xml.new(
          name: element,
          attribute: to,
          methods: using,
          namespace: Descriptor::XmlNamespace.new(nsp, pfx)
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
        Validator.validate_arguments(attribute, to, using)
        Validator.validate_namespace(attribute, namespace, prefix)

        namespaced_attribute = [namespace, attribute].compact.join(':')

        @attributes[namespaced_attribute] = Descriptor::Xml.new(
          name: attribute,
          attribute: to,
          methods: using,
          namespace: Descriptor::XmlNamespace.new(namespace, prefix)
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
    end
  end
end
