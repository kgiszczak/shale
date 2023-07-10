# frozen_string_literal: true

module Shale
  # Class representing object's attribute
  #
  # @api private
  class Attribute
    # Return name
    #
    # @api private
    attr_reader :name

    # Return type
    #
    # @api private
    attr_reader :type

    # Return default
    #
    # @api private
    attr_reader :default

    # Return nullable
    #
    # @api private
    attr_reader :nullable

    # Return properties
    #
    # @api public
    attr_accessor :validations

    # Return required
    #
    # @api public
    attr_accessor :required

    # Return setter name
    #
    # @api private
    attr_reader :setter

    # Initialize Attribute object
    #
    # @param [Symbol] name Name of the attribute
    # @param [Shale::Type::Value] type Type of the attribute
    # @param [Boolean] collection Is this attribute a collection
    # @param [Proc] default Default value
    #
    # @api private
    def initialize(name, type, collection, default, nullable, validations, required)
      @name = name
      @setter = "#{name}="
      @type = type
      @collection = collection
      @default = collection ? -> { [] } : default
      @nullable = nullable
      @validations = validations
      @required = required
    end

    # Return wheter attribute is collection or not
    #
    # @return [Boolean]
    #
    # @api private
    def collection?
      @collection == true
    end
  end
end
