# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    class Boolean < Base
      FALSE_VALUES = [
        false,
        0,
        '0',
        'f',
        'F',
        'false',
        'FALSE',
        'off',
        'OFF',
      ].freeze

      def self.cast(value)
        !FALSE_VALUES.include?(value) unless value.nil?
      end
    end
  end
end
