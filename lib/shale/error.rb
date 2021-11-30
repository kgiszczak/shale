# frozen_string_literal: true

module Shale
  # Error for assigning value to not existing attribute
  #
  # @api private
  class UnknownAttributeError < NoMethodError
    # Initialize error object
    #
    # @param [String] record
    # @param [String] attribute
    #
    # @api private
    def initialize(record, attribute)
      super("unknown attribute '#{attribute}' for #{record}.")
    end
  end

  # Error for trying to assign not callable object as an attribute's default
  #
  # @api private
  class DefaultNotCallableError < StandardError
    # Initialize error object
    #
    # @param [String] record
    # @param [String] attribute
    #
    # @api private
    def initialize(record, attribute)
      super("'#{attribute}' default is not callable for #{record}.")
    end
  end
end
