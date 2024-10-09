# frozen_string_literal: true

module Shale
  module Type
    class << self
      # Register a symbol alias for a Shale::Type::Value class
      #
      # @param [Symbol] type Short type alias
      # @param [Shale::Type::Value] klass Class to register
      #
      # @raise [NotATypeValueError] when klass is not a Shale::Type::Value
      #
      # @example
      #   class UnixTimestamp < Shale::Type::Value
      #     def self.cast(value)
      #       Time.at(value.to_i)
      #     end
      #   end
      #
      #   Shale::Type.register(:unix_timestamp, UnixTimestamp)
      #
      # @api public
      def register(type, klass)
        @registry ||= {}

        unless klass < Value
          raise NotATypeValueError, "class '#{klass}' is not a valid Shale::Type::Value"
        end

        @registry[type] = klass
      end

      # Lookup a Shale::Type::Value class by type alias
      #
      # @param [Symbol] type Type alias
      #
      # @raise [UnknownTypeError] when type is not registered
      #
      # @return [Shale::Type::Value] Class registered for type
      #
      # @example
      #
      #  Shale::Type.lookup(:unix_timestamp)
      #  # => UnixTimestamp
      #
      # @api public
      def lookup(type)
        klass = @registry[type]

        raise UnknownTypeError, "unknown type '#{type}'" unless klass

        klass
      end
    end
  end
end
