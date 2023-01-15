# frozen_string_literal: true

require_relative '../../utils'

module Shale
  module Schema
    module Compiler
      # Class representing Shale's complex type
      #
      # @api private
      class Complex
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

        # Root name setter
        #
        # @param [String] val
        #
        # @api private
        attr_writer :root_name

        # Initialize object
        #
        # @param [String] id
        # @param [String] root_name
        # @param [String, nil] package
        #
        # @api private
        def initialize(id, root_name, package)
          @id = id
          @root_name = root_name
          @package = package ? Utils.classify(package) : nil
          @properties = []
        end

        # Return base name
        #
        # @return [String]
        #
        # @api private
        def root_name
          Utils.classify(@root_name)
        end

        # Return namespaced name
        #
        # @return [String]
        #
        # @api private
        def name
          Utils.classify([@package, @root_name].compact.join('::'))
        end

        # Return module names
        #
        # @return [Array<String>]
        #
        # @api private
        def modules
          (@package || '').split('::')
        end

        # Return file name
        #
        # @return [String]
        #
        # @api private
        def file_name
          Utils.snake_case(name)
        end

        # Return relative path to target
        #
        # @param [String] target
        #
        # @return [String]
        #
        # @api private
        def relative_path(target)
          base_paths = file_name.split('/')
          target_paths = target.split('/')

          common_paths_length = 0

          base_paths.length.times do |i|
            break if base_paths[i] != target_paths[i]
            common_paths_length += 1
          end

          unique_base_paths = base_paths[common_paths_length..-1]
          unique_target_paths = target_paths[common_paths_length..-1]

          ((0...unique_base_paths.length - 1).map { '..' } + unique_target_paths).join('/')
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
            .sort { |a, b| a.type.file_name <=> b.type.file_name }
        end

        # Add property to Object
        #
        # @param [Shale::Schema::Compiler::Property] property
        #
        # @api private
        def add_property(property)
          unless @properties.find { |e| e.mapping_name == property.mapping_name }
            @properties << property
          end
        end
      end
    end
  end
end
