# frozen_string_literal: true

require_relative 'schema/json'

module Shale
  # Module for handling JSON and XML schema
  #
  # @api private
  module Schema
    # Generate JSON schema from Shale model
    #
    # @param [Shale::Mapper] klass
    # @param [String, nil] id
    # @param [String, nil] description
    # @param [true, false] pretty
    #
    # @return String
    #
    # @example
    #   Shale::Schema.to_json(Person, id: 'My ID', description: 'My description', pretty: true)
    #   # => JSON schema
    #
    # @api public
    def self.to_json(klass, id: nil, description: nil, pretty: false)
      JSON.new.to_schema(klass, id: id, description: description, pretty: pretty)
    end
  end
end
