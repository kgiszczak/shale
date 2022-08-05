# frozen_string_literal: true

module Shale
  module Adapter
    module REXML
      # Wrapper around REXML API
      #
      # @api private
      class Document
        # Initialize object
        #
        # @api private
        def initialize
          context = { attribute_quote: :quote, prologue_quote: :quote }
          @doc = ::REXML::Document.new(nil, context)
          @namespaces = {}
        end

        # Return REXML document
        #
        # @return [::REXML::Document]
        #
        # @api private
        def doc
          if @doc.root
            @namespaces.each do |prefix, namespace|
              @doc.root.add_namespace(prefix, namespace)
            end
          end

          @doc
        end

        # Create REXML element
        #
        # @param [String] name Name of the XML element
        #
        # @return [::REXML::Element]
        #
        # @api private
        def create_element(name)
          ::REXML::Element.new(name, nil, attribute_quote: :quote)
        end

        # Create CDATA node and add it to parent
        #
        # @param [String] text
        # @param [::REXML::Element] parent
        #
        # @api private
        def create_cdata(text, parent)
          ::REXML::CData.new(text, true, parent)
        end

        # Add XML namespace to document
        #
        # @param [String] prefix
        # @param [String] namespace
        #
        # @api private
        def add_namespace(prefix, namespace)
          @namespaces[prefix] = namespace if prefix && namespace
        end

        # Add attribute to REXML element
        #
        # @param [::REXML::Element] element REXML element
        # @param [String] name Name of the XML attribute
        # @param [String] value Value of the XML attribute
        #
        # @api private
        def add_attribute(element, name, value)
          element.add_attribute(name, value || '')
        end

        # Add child element to REXML element
        #
        # @param [::REXML::Element] element REXML parent element
        # @param [::REXML::Element] child REXML child element
        #
        # @api private
        def add_element(element, child)
          element.add_element(child)
        end

        # Add text node to REXML element
        #
        # @param [::REXML::Element] element REXML element
        # @param [String] text Text to add
        #
        # @api private
        def add_text(element, text)
          element.add_text(text)
        end
      end
    end
  end
end
