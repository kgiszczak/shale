# frozen_string_literal: true

require_relative 'value'

module Shale
  module Type
    # Cast value to BigDecimal
    #
    # @api public
    class Decimal < Value
      class << self
        # @param [String, Float, Integer, nil] value Value to cast
        #
        # @return [BigDecimal, nil]
        #
        # @api private
        def cast(value)
          return if value.nil?

          case value
          when ::BigDecimal then value
          when ::Float then BigDecimal(value, value.to_s.length)
          else BigDecimal(value)
          end
        end

        def as_json(value, **)
          value.to_f
        end

        def as_yaml(value, **)
          value.to_f
        end

        def as_csv(value, **)
          value.to_f
        end

        def as_toml(value, **)
          value.to_f
        end

        def as_xml_value(value, **)
          value.to_s('F')
        end
      end
    end

    register(:decimal, Decimal)
  end
end
