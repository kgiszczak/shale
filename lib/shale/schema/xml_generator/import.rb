# frozen_string_literal: true

module Shale
  module Schema
    class XMLGenerator
      # Class representing XML Schema <import> element
      #
      # @api private
      class Import
        # Return namespace
        #
        # @return [String]
        #
        # @api private
        attr_reader :namespace

        # Initialize Import object
        #
        # @param [String, nil] namespace
        # @param [String, nil] location
        #
        # @api private
        def initialize(namespace, location)
          @namespace = namespace
          @location = location
        end

        # Append element to the XML document
        #
        # @param [Shale::Adapter::<XML adapter>::Document] doc
        #
        # @return [Shale::Adapter::<XML adapter>::Node]
        #
        # @api private
        def as_xml(doc)
          import = doc.create_element('xs:import')

          doc.add_attribute(import, 'namespace', @namespace) if @namespace
          doc.add_attribute(import, 'schemaLocation', @location) if @location

          import
        end
      end
    end
  end
end
