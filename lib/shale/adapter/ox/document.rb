# frozen_string_literal: true

module Shale
  module Adapter
    module Ox
      # Wrapper around Ox API
      #
      # @api private
      class Document
        # Return Ox document
        #
        # @return [::Ox::Document]
        #
        # @api private
        attr_reader :doc

        # Initialize object
        #
        # @api private
        def initialize
          @doc = ::Ox::Document.new
        end

        # Create Ox element
        #
        # @param [String] name Name of the XML element
        #
        # @return [::Ox::Element]
        #
        # @api private
        def create_element(name)
          ::Ox::Element.new(name)
        end

        # Add XML namespace to document
        #
        # Ox doesn't support XML namespaces so this method does nothing.
        #
        # @param [String] prefix
        # @param [String] namespace
        #
        # @api private
        def add_namespace(prefix, namespace)
          # :noop:
        end

        # Add attribute to Ox element
        #
        # @param [::Ox::Element] element Ox element
        # @param [String] name Name of the XML attribute
        # @param [String] value Value of the XML attribute
        #
        # @api private
        def add_attribute(element, name, value)
          element[name] = value
        end

        # Add child element to Ox element
        #
        # @param [::Ox::Element] element Ox parent element
        # @param [::Ox::Element] child Ox child element
        #
        # @api private
        def add_element(element, child)
          element << child
        end

        # Add text node to Ox element
        #
        # @param [::Ox::Element] element Ox element
        # @param [String] text Text to add
        #
        # @api private
        def add_text(element, text)
          element << text
        end
      end
    end
  end
end
