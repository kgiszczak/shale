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
        #
        # @api private
        def initialize(name, properties)
          super(name)
          @properties = properties
        end

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_type
          {
            'type' => 'object',
            'properties' => @properties.to_h { |el| [el.name, el.as_json] }
         }.tap { |type|
          required = @properties.select(&:required).map(&:name)
          type['required'] = required unless required.empty? 
        }
        end
      end
    end
  end
end
