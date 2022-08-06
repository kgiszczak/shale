# frozen_string_literal: true

require 'nokogiri'

require_relative '../error'
require_relative 'nokogiri/document'
require_relative 'nokogiri/node'

module Shale
  module Adapter
    # Nokogiri adapter
    #
    # @api public
    module Nokogiri
      # Parse XML into Nokogiri document
      #
      # @param [String] xml XML document
      #
      # @raise [ParseError] when XML document has errors
      #
      # @return [Shale::Adapter::Nokogiri::Node]
      #
      # @api private
      def self.load(xml)
        doc = ::Nokogiri::XML::Document.parse(xml) do |config|
          config.noblanks
        end

        unless doc.errors.empty?
          raise ParseError, "Document is invalid: #{doc.errors}"
        end

        Node.new(doc.root)
      end

      # Serialize Nokogiri document into XML
      #
      # @param [::Nokogiri::XML::Document] doc Nokogiri document
      # @param [true, false] pretty
      # @param [true, false] declaration
      #
      # @return [String]
      #
      # @api private
      def self.dump(doc, pretty: false, declaration: false)
        save_with = ::Nokogiri::XML::Node::SaveOptions::AS_XML

        if pretty
          save_with |= ::Nokogiri::XML::Node::SaveOptions::FORMAT
        end

        unless declaration
          save_with |= ::Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
        end

        result = doc.to_xml(save_with: save_with)

        unless pretty
          result = result.sub(/\n/, '')
        end

        result
      end

      # Create Shale::Adapter::Nokogiri::Document instance
      #
      # @api private
      def self.create_document
        Document.new
      end
    end
  end
end
