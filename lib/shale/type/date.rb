# frozen_string_literal: true

require 'date'
require_relative 'base'

module Shale
  module Type
    class Date < Base
      def self.cast(value)
        ::Date.parse(value) unless value.empty?
      end
    end
  end
end
