# frozen_string_literal: true

module Shale
  module Mapping
    # Class for handling attribute delegation
    #
    # @api private
    class Delegates
      # Class representing individual delegation
      #
      # @api private
      class Delegate
        # Return receiver_attribute
        #
        # @return [Shale::Attribute]
        #
        # @api private
        attr_reader :receiver_attribute

        # Return attribute setter on a delegate
        #
        # @return [String]
        #
        # @api private
        attr_reader :setter

        # Return value to set on a delegate
        #
        # @return [any]
        #
        # @api private
        attr_reader :value

        # Initialize instance
        #
        # @param [Shale::Attribute] receiver_attribute
        # @param [String] setter
        # @param [any] value
        #
        # @api private
        def initialize(receiver_attribute, setter, value)
          @receiver_attribute = receiver_attribute
          @setter = setter
          @value = value
        end
      end

      # Initialize instance
      #
      # @api private
      def initialize
        @delegates = []
      end

      # Add single value to delegate
      #
      # @param [Shale::Attribute] receiver_attribute
      # @param [String] setter
      # @param [any] value
      #
      # @api private
      def add(receiver_attribute, setter, value)
        @delegates << Delegate.new(receiver_attribute, setter, value)
      end

      # Add collection to delegate
      #
      # @param [Shale::Attribute] receiver_attribute
      # @param [String] setter
      # @param [any] value
      #
      # @api private
      def add_collection(receiver_attribute, setter, value)
        delegate = @delegates.find do |e|
          e.receiver_attribute == receiver_attribute && e.setter == setter
        end

        if delegate
          delegate.value << value
        else
          @delegates << Delegate.new(receiver_attribute, setter, [value])
        end
      end

      # Iterate over delegates and yield a block
      #
      # @param [Proc] block
      #
      # @api private
      def each(&block)
        @delegates.each(&block)
      end
    end
  end
end
