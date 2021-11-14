# frozen_string_literal: true

require 'time'
require_relative 'base'

module Shale
  module Type
    class Time < Base
      def self.cast(value)
        if value.is_a?(::String)
          return if value.empty?
          ::Time.parse(value)
        elsif value.respond_to?(:to_time)
          value.to_time
        else
          value
        end
      end
    end
  end
end
