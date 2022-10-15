# frozen_string_literal: true

module Shale
  module Adapter
    module Nokogiri
      # Wrapper around Nokogiri API
      #
      # @api private
      class Document
        # Initialize object
        #
        # @param [String, nil] version
        #
        # @api private
        def initialize(version = nil)
          ver = nil
          ver = version if version.is_a?(String)

          @doc = ::Nokogiri::XML::Document.new(ver)
          @namespaces = {}
        end

        # Return Nokogiri document
        #
        # @return [::Nokogiri::XML::Document]
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

        # Create Nokogiri element
        #
        # @param [String] name Name of the XML element
        #
        # @return [::Nokogiri::XML::Element]
        #
        # @api private
        def create_element(name)
          ::Nokogiri::XML::Element.new(name, @doc)
        end

        # Create CDATA node and add it to parent
        #
        # @param [String] text
        # @param [::Nokogiri::XML::Element] parent
        #
        # @api private
        def create_cdata(text, parent)
          parent.add_child(::Nokogiri::XML::CDATA.new(@doc, text))
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

        # Add attribute to Nokogiri element
        #
        # @param [::Nokogiri::XML::Element] element Nokogiri element
        # @param [String] name Name of the XML attribute
        # @param [String] value Value of the XML attribute
        #
        # @api private
        def add_attribute(element, name, value)
          element[name] = value
        end

        # Add child element to Nokogiri element
        #
        # @param [::Nokogiri::XML::Element] element Nokogiri parent element
        # @param [::Nokogiri::XML::Element] child Nokogiri child element
        #
        # @api private
        def add_element(element, child)
          element.add_child(child)
        end

        # Add text node to Nokogiri element
        #
        # @param [::Nokogiri::XML::Element] element Nokogiri element
        # @param [String] text Text to add
        #
        # @api private
        def add_text(element, text)
          element.content = text
        end
      end
    end
  end
end
