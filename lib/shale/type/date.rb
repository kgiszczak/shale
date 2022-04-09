# frozen_string_literal: true

require 'date'
require_relative 'value'

module Shale
  module Type
    # Cast value to Date
    #
    # @api public
    class Date < Value
      # @param [any] value Value to cast
      #
      # @return [Date, nil]
      #
      # @api private
      def self.cast(value)
        if value.is_a?(::String)
          return if value.empty?
          ::Date.parse(value)
        elsif value.respond_to?(:to_date)
          value.to_date
        else
          value
        end
      end

      # Use ISO 8601 format in JSON document
      #
      # @param [Date] value
      #
      # @return [String]
      #
      # @api private
      def self.as_json(value)
        value&.iso8601
      end

      # Use ISO 8601 format in YAML document
      #
      # @param [Date] value
      #
      # @return [String]
      #
      # @api private
      def self.as_yaml(value)
        value&.iso8601
      end

      # Use ISO 8601 format in XML document
      #
      # @param [Date] value Value to convert to XML
      # @param [String] name Name of the element
      # @param [Shale::Adapter::<XML adapter>::Document] doc Document
      #
      # @api private
      def self.as_xml(value, name, doc)
        element = doc.create_element(name)
        doc.add_text(element, value&.iso8601)
        element
      end
    end
  end
end
