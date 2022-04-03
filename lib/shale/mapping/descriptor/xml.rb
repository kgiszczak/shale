# frozen_string_literal: true

require_relative 'dict'

module Shale
  module Mapping
    module Descriptor
      # Class representing XML attribute mapping
      #
      # @api private
      class Xml < Dict
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
end
