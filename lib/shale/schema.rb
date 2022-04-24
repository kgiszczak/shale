# frozen_string_literal: true

require_relative 'schema/json'
require_relative 'schema/xml'

module Shale
  # Module for handling JSON and XML schema
  #
  # @api private
  module Schema
    # Generate JSON Schema from Shale model
    #
    # @param [Shale::Mapper] klass
    # @param [String, nil] id
    # @param [String, nil] description
    # @param [true, false] pretty
    #
    # @return [String]
    #
    # @example
    #   Shale::Schema.to_json(Person, id: 'My ID', description: 'My description', pretty: true)
    #   # => JSON schema
    #
    # @api public
    def self.to_json(klass, id: nil, description: nil, pretty: false)
      JSON.new.to_schema(klass, id: id, description: description, pretty: pretty)
    end

    # Generate XML Schema from Shale model
    #
    # @param [Shale::Mapper] klass
    # @param [String, nil] base_name
    # @param [true, false] pretty
    # @param [true, false] declaration
    #
    # @return [Hash<String, String>]
    #
    # @example
    #   Shale::Schema.to_xml(Person, pretty: true, declaration: true)
    #   # => { 'schema0.xsd' => <JSON schema>, 'schema1.xsd' => <JSON schema> }
    #
    # @api public
    def self.to_xml(klass, base_name = nil, pretty: false, declaration: false)
      XML.new.to_schemas(klass, base_name, pretty: pretty, declaration: declaration)
    end
  end
end
