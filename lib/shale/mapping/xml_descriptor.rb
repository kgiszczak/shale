# frozen_string_literal: true

require_relative 'descriptor'

module Shale
  module Mapping
    # Class representing XML attribute mapping
    #
    # @api private
    class XmlDescriptor < Descriptor
      # Return namespace
      #
      # @return [String]
      #
      # @api private
      attr_reader :namespace

      # Initialize instance
      #
      # @param [String] name
      # @param [Symbol, String] attribute
      # @param [Hash, nil] methods
      # @param [Shale::Mapping::XmlNamespace] namespace
      #
      # @api private
      def initialize(name:, attribute:, methods:, namespace:)
        super(name: name, attribute: attribute, methods: methods)
        @namespace = namespace
      end

      # Return name with XML prefix
      #
      # @return [String]
      #
      # @api private
      def prefixed_name
        [namespace.prefix, name].compact.join(':')
      end
    end
  end
end
