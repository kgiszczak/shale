# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    # Cast value to String
    #
    # @api public
    class String < Base
      # @param [#to_s, nil] value Value to cast
      #
      # @return [String, nil]
      #
      # @api private
      def self.cast(value)
        value&.to_s
      end
    end
  end
end
