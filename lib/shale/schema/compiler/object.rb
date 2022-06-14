# frozen_string_literal: true

require_relative 'utils'

module Shale
  module Schema
    module Compiler
      # Class representing Shale's comosite type
      #
      # @api private
      class Object
        # Return id
        #
        # @return [String]
        #
        # @api private
        attr_reader :id

        # Return properties
        #
        # @return [Array<Shale::Schema::Compiler::Property>]
        #
        # @api private
        attr_reader :properties

        # Name setter
        #
        # @param [String] val
        #
        # @api private
        attr_writer :name

        # Initialize object
        #
        # @param [String] id
        # @param [String] name
        #
        # @api private
        def initialize(id, name)
          @id = id
          @name = name
          @properties = []
        end

        # Return name
        #
        # @return [String]
        #
        # @api private
        def name
          Utils.classify(@name)
        end

        # Return file name
        #
        # @return [String]
        #
        # @api private
        def file_name
          Utils.snake_case(@name)
        end

        # Return references
        #
        # @return [Array<Shale::Schema::Compiler::Property>]
        #
        # @api private
        def references
          @properties
            .filter { |e| e.type.is_a?(self.class) && e.type != self }
            .uniq { |e| e.type.id }
        end

        # Add property to Object
        #
        # @param [Shale::Schema::Compiler::Property] property
        #
        # @api private
        def add_property(property)
          @properties << property
        end
      end
    end
  end
end
