# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    class Float < Base
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
  end
end
