# frozen_string_literal: true

require 'time'
require_relative 'base'

module Shale
  module Type
    class Time < Base
      def self.cast(value)
        ::Time.parse(value) unless value.empty?
      end
    end
  end
end
