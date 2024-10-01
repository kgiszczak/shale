# frozen_string_literal: true

require 'time'
require_relative 'value'

module Shale
  module Type
    # Cast value to Time
    #
    # @api public
    class Time < Value
      # @param [any] value Value to cast
      #
      # @return [Time, nil]
      #
      # @api private
      def self.cast(value)
        if value.is_a?(::String)
          return if value.empty?
          ::Time.parse(value)
        elsif value.respond_to?(:to_time)
          value.to_time
        else
          value
        end
      end

      # Use ISO 8601 format in JSON document
      #
      # @param [Time] value
      #
      # @return [String]
      #
      # @api private
      def self.as_json(value, **)
        value&.iso8601
      end

      # Use ISO 8601 format in YAML document
      #
      # @param [Time] value
      #
      # @return [String]
      #
      # @api private
      def self.as_yaml(value, **)
        value&.iso8601
      end

      # Use ISO 8601 format in CSV document
      #
      # @param [Time] value
      #
      # @return [String]
      #
      # @api private
      def self.as_csv(value, **)
        value&.iso8601
      end

      # Use ISO 8601 format in XML document
      #
      # @param [Time] value Value to convert to XML
      #
      # @return [String]
      #
      # @api private
      def self.as_xml_value(value)
        value&.iso8601
      end
    end

    register(:time, Time)
  end
end
