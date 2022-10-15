# frozen_string_literal: true

require 'rexml/document'

require_relative '../error'
require_relative 'rexml/document'
require_relative 'rexml/node'

module Shale
  module Adapter
    # REXML adapter
    #
    # @api public
    module REXML
      # Parse XML into REXML document
      #
      # @param [String] xml XML document
      #
      # @raise [ParseError] when XML document has errors
      #
      # @return [Shale::Adapter::REXML::Node]
      #
      # @api private
      def self.load(xml)
        doc = ::REXML::Document.new(xml, ignore_whitespace_nodes: :all)
        Node.new(doc.root)
      rescue ::REXML::ParseException => e
        raise ParseError, "Document is invalid: #{e.message}"
      end

      # Serialize REXML document into XML
      #
      # @param [::REXML::Document] doc REXML document
      # @param [true, false] pretty
      # @param [true, false, String] declaration
      # @param [true, false, String] encoding
      #
      # @return [String]
      #
      # @api private
      def self.dump(doc, pretty: false, declaration: false, encoding: false)
        if declaration
          ver = nil
          enc = nil

          if declaration.is_a?(String)
            ver = declaration
          end

          if encoding == true
            enc = 'UTF-8'
          else
            enc = encoding || nil
          end

          doc.add(::REXML::XMLDecl.new(ver, enc))
        end

        io = StringIO.new

        if pretty
          formatter = ::REXML::Formatters::Pretty.new
          formatter.compact = true
        else
          formatter = ::REXML::Formatters::Default.new
        end

        formatter.write(doc, io)
        io.string
      end

      # Create Shale::Adapter::REXML::Document instance
      #
      # @api private
      def self.create_document(_version = nil)
        Document.new
      end
    end
  end
end
