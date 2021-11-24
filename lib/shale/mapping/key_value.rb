# frozen_string_literal: true

module Shale
  module Mapping
    class KeyValue
      attr_reader :keys

      def initialize
        @keys = {}
      end

      def map(key, to:)
        @keys[key] = to
      end

      def initialize_dup(other)
        @keys = other.instance_variable_get('@keys').dup
        super
      end
    end
  end
end
