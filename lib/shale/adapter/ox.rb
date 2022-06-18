# frozen_string_literal: true

require 'ox'

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
      # @return [::Ox::Document, ::Ox::Element]
      #
      # @api private
      def self.load(xml)
        Node.new(::Ox.parse(xml))
      end

      # Serialize Ox document into XML
      #
      # @param [::Ox::Document, ::Ox::Element] doc Ox document
      # @param [Array<Symbol>] options
      #
      # @return [String]
      #
      # @api private
      def self.dump(doc, *options)
        opts = { indent: -1, with_xml: false }

        if options.include?(:pretty)
          opts[:indent] = 2
        end

        if options.include?(:declaration)
          doc[:version] = '1.0'
          opts[:with_xml] = true
        end

        ::Ox.dump(doc, opts).sub(/\A\n/, '')
      end

      # Create Shale::Adapter::Ox::Document instance
      #
      # @api private
      def self.create_document
        Document.new
      end
    end
  end
end
