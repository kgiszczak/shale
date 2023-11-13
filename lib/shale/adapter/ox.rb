# frozen_string_literal: true

require 'ox'

require_relative '../error'
require_relative 'ox/document'
require_relative 'ox/node'

module Shale
  module Adapter
    # Ox adapter
    #
    # @api public
    module Ox
      # Parse XML into Ox document
      #
      # @param [String] xml XML document
      #
      # @raise [ParseError] when XML document has errors
      #
      # @return [Shale::Adapter::Ox::Node]
      #
      # @api private
      def self.load(xml)
        element = ::Ox.parse(xml)
        Node.new(element.respond_to?(:root) ? element.root : element)
      rescue ::Ox::ParseError => e
        raise ParseError, "Document is invalid: #{e.message}"
      end

      # Serialize Ox document into XML
      #
      # @param [::Ox::Document, ::Ox::Element] doc Ox document
      # @param [true, false] pretty
      # @param [true, false, String] declaration
      # @param [true, false, String] encoding
      #
      # @return [String]
      #
      # @api private
      def self.dump(doc, pretty: false, declaration: false, encoding: false)
        opts = { indent: -1, with_xml: false }

        if pretty
          opts[:indent] = 2
        end

        if declaration
          doc[:version] = declaration == true ? '1.0' : declaration

          if encoding
            doc[:encoding] = encoding == true ? 'UTF-8' : encoding
          end

          opts[:with_xml] = true
        end

        ::Ox.dump(doc, opts).sub(/\A\n/, '')
      end

      # Create Shale::Adapter::Ox::Document instance
      #
      # @api private
      def self.create_document(_version = nil)
        Document.new
      end
    end
  end
end
