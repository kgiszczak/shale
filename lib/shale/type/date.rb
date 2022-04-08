# frozen_string_literal: true

require 'date'
require_relative 'value'

module Shale
  module Type
    # Cast value to Date
    #
    # @api public
    class Date < Value
      # @param [any] value Value to cast
      #
      # @return [Date, nil]
      #
      # @api private
      def self.cast(value)
        if value.is_a?(::String)
          return if value.empty?
          ::Date.parse(value)
        elsif value.respond_to?(:to_date)
          value.to_date
        else
          value
        end
      end
    end
  end
end
