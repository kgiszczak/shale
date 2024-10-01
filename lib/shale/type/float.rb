# frozen_string_literal: true

require_relative 'value'

module Shale
  module Type
    # Cast value to Float
    #
    # @api public
    class Float < Value
      # @param [#to_f, String, nil] value Value to cast
      #
      # @return [Float, nil]
      #
      # @api private
      def self.cast(value)
        return if value.nil?

        case value
        when ::Float then value
        when 'Infinity' then ::Float::INFINITY
        when '-Infinity' then -::Float::INFINITY
        when 'NaN' then ::Float::NAN
        else value.to_f
        end
      end
    end

    register(:float, Float)
  end
end
