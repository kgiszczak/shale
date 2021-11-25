# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    class Integer < Base
      def self.cast(value)
        value&.to_i
      end
    end
  end
end
