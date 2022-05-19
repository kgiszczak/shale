# frozen_string_literal: true

module Shale
  module Schema
    class XMLGenerator
      # Class representing XML Schema <element> element.
      # Serves as a base class for TypedElement and RefElement
      #
      # @api private
      class Element
        # Initialize Element object
        #
        # @param [String, nil] default
        # @param [true, false] collection
        # @param [true, false] required
        #
        # @api private
        def initialize(default, collection, required)
          @default = default
          @collection = collection
          @required = required
        end

        # Append element to the XML document
        #
        # @param [Shale::Adapter::<XML adapter>::Document] doc
        #
        # @return [Shale::Adapter::<XML adapter>::Node]
        #
        # @api private
        def as_xml(doc)
          element = doc.create_element('xs:element')

          attributes.each do |name, value|
            doc.add_attribute(element, name, value)
          end

          unless @required
            doc.add_attribute(element, 'minOccurs', 0)
          end

          if @collection
            doc.add_attribute(element, 'maxOccurs', 'unbounded')
          end

          unless @default.nil?
            doc.add_attribute(element, 'default', @default)
          end

          element
        end
      end
    end
  end
end
