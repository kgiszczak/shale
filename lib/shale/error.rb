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

  # Error for passing incorrect arguments to map functions
  #
  # @api private
  class IncorrectMappingArgumentsError < StandardError
  end

  # Error for passing incorrect arguments to schema generation function
  #
  # @api private
  class NotAShaleMapperError < StandardError
  end

  # JSON Schema compilation error
  #
  # @api private
  class JSONSchemaError < StandardError
  end
end
