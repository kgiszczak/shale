# frozen_string_literal: true

require_relative 'complex'

module Shale
  module Schema
    module Compiler
      # Class representing Shale's XML complex type
      #
      # @api private
      class XMLComplex < Complex
        # Accessor for root attribute
        #
        # @return [String]
        #
        # @api private
        attr_accessor :root

        # Return namespace prefix
        #
        # @return [String]
        #
        # @api private
        attr_reader :prefix

        # Return namespace URI
        #
        # @return [String]
        #
        # @api private
        attr_reader :namespace

        # Initialize object
        #
        # @param [String] id
        # @param [String] root_name
        # @param [String] prefix
        # @param [String] namespace
        # @param [String, nil] package
        #
        # @api private
        def initialize(id, root_name, prefix, namespace, package)
          super(id, root_name, package)
          @root = root_name
          @prefix = prefix
          @namespace = namespace
        end
      end
    end
  end
end
