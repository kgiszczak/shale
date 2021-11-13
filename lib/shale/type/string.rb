# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    class String < Base
      def self.cast(value)
        value.to_s unless value.nil?
      end
    end
  end
end
