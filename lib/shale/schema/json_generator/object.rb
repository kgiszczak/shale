# frozen_string_literal: true

require_relative 'base'

module Shale
  module Schema
    class JSONGenerator
      # Class representing JSON Schema object type
      #
      # @api private
      class Object < Base
        # Initialize object
        #
        # @param [String] name
        # @param [
        #   Array<Shale::Schema::JSONGenerator::Base,
        #   Shale::Schema::JSONGenerator::Collection>
        # ] properties
        # @param [Hash] root
        #
        # @api private
        def initialize(name, properties, root)
          super(name)
          @root = root
          @properties = properties
        end

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          required_props = @properties.filter_map { |prop| prop.name if prop&.schema&.[](:required) }

          {
            'type' => 'object',
            'properties' => @properties.to_h { |el| [el.name, el.as_json] },
            'required' => required_props.empty? ? nil : required_props,
            'minProperties' => @root[:min_properties],
            'maxProperties' => @root[:max_properties],
            'dependentRequired' => @root[:dependent_required],
            'description' => @root[:description],
            'additionalProperties' => @root[:additional_properties],
          }.compact
        end
      end
    end
  end
end
