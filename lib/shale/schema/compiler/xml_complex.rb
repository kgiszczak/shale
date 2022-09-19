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
        # @param [String] name
        # @param [String] prefix
        # @param [String] namespace
        #
        # @api private
        def initialize(id, name, prefix, namespace, ruby_namespace = nil)
          super(id, name)
          @root = name
          @prefix = prefix
          @namespace = namespace
          @ruby_namespace = ruby_namespace
        end

        def ruby_class_name
          [@ruby_namespace, name].compact.join('::')
        end
      end
    end
  end
end
