# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    class String < Base
      def self.cast(value)
        value&.to_s
      end
    end
  end
end
