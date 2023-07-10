# frozen_string_literal: true

module Shale
  module Schema
    class JSONGenerator
      # Base class for JSON Schema types
      #
      # @api private
      class Base
        # Return name
        #
        # @api private
        attr_reader :name

        # Return default
        #
        # @api private
        attr_reader :default

        # Return nullable
        #
        # @api private
        attr_writer :nullable

        # Return validations
        #
        # @api private
        attr_reader :validations

        # Return properties
        #
        # @api private
        attr_reader :required

        def initialize(name, default: nil, nullable: true, validations: nil, required: false)
          @name = name.gsub('::', '_')
          @default = default
          @nullable = nullable
          @validations = validations&.transform_keys(&:to_sym)
          @required = required
        end

        # Return JSON Schema fragment as Ruby Hash
        #
        # @return [Hash]
        #
        # @api private
        def as_json
          type = as_type
          type['type'] = [*type['type'], 'null'] if type['type'] && @nullable
          type['default'] = @default unless @default.nil?

          type
        end

        def validators
          return {} if validations.nil?
          return {} unless self.class.const_defined?(:VALIDATORS)

          self.class::VALIDATORS.reduce({}) do |hash, validator|
            value = validations[validator.to_sym]
            hash[validator.to_sym] = value unless value.nil?
            
            hash
          end
        end

        def as_type
          raise NotImplementedError
        end

      end
    end
  end
end
