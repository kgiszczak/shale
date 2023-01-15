# frozen_string_literal: true

require_relative 'descriptor/xml'
require_relative 'descriptor/xml_namespace'
require_relative 'validator'

module Shale
  module Mapping
    # Base class for Mapping XML serialization format
    #
    # @api private
    class XmlBase
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
        @finalized = false
        @render_nil_default = false
      end

      # Map element to attribute
      #
      # @param [String] element
      # @param [Symbol, nil] to
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      # @param [String, nil] group
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      # @param [true, false] cdata
      # @param [true, false, nil] render_nil
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map_element(
        element,
        to: nil,
        receiver: nil,
        using: nil,
        group: nil,
        namespace: :undefined,
        prefix: :undefined,
        cdata: false,
        render_nil: nil
      )
        Validator.validate_arguments(element, to, receiver, using)
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
          receiver: receiver,
          methods: using,
          group: group,
          namespace: Descriptor::XmlNamespace.new(nsp, pfx),
          cdata: cdata,
          render_nil: render_nil.nil? ? @render_nil_default : render_nil
        )
      end

      # Map document's attribute to object's attribute
      #
      # @param [String] attribute
      # @param [Symbol, nil] to
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      # @param [String, nil] group
      # @param [String, nil] namespace
      # @param [String, nil] prefix
      # @param [true, false, nil] render_nil
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map_attribute(
        attribute,
        to: nil,
        receiver: nil,
        using: nil,
        group: nil,
        namespace: nil,
        prefix: nil,
        render_nil: nil
      )
        Validator.validate_arguments(attribute, to, receiver, using)
        Validator.validate_namespace(attribute, namespace, prefix)

        namespaced_attribute = [namespace, attribute].compact.join(':')

        @attributes[namespaced_attribute] = Descriptor::Xml.new(
          name: attribute,
          attribute: to,
          receiver: receiver,
          methods: using,
          namespace: Descriptor::XmlNamespace.new(namespace, prefix),
          cdata: false,
          group: group,
          render_nil: render_nil.nil? ? @render_nil_default : render_nil
        )
      end

      # Map document's content to object's attribute
      #
      # @param [Symbol] to
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      # @param [String, nil] group
      # @param [true, false] cdata
      #
      # @api private
      def map_content(to: nil, receiver: nil, using: nil, group: nil, cdata: false)
        Validator.validate_arguments('content', to, receiver, using)

        @content = Descriptor::Xml.new(
          name: nil,
          attribute: to,
          receiver: receiver,
          methods: using,
          namespace: Descriptor::XmlNamespace.new(nil, nil),
          cdata: cdata,
          group: group,
          render_nil: false
        )
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

      # Set the "finalized" instance variable to true
      #
      # @api private
      def finalize!
        @finalized = true
      end

      # Query the "finalized" instance variable
      #
      # @return [truem false]
      #
      # @api private
      def finalized?
        @finalized
      end

      # @api private
      def initialize_dup(other)
        @elements = other.instance_variable_get('@elements').dup
        @attributes = other.instance_variable_get('@attributes').dup
        @default_namespace = other.instance_variable_get('@default_namespace').dup
        @finalized = false

        super
      end
    end
  end
end
