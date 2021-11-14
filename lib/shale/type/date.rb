# frozen_string_literal: true

require 'date'
require_relative 'base'

module Shale
  module Type
    class Date < Base
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
