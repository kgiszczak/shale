# frozen_string_literal: true

require_relative 'schema/json_generator'
require_relative 'schema/json_compiler'
require_relative 'schema/xml_generator'
require_relative 'schema/xml_compiler'

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
    def self.to_json(klass, id: nil, title: nil, description: nil, pretty: false)
      JSONGenerator.new.to_schema(
        klass,
        id: id,
        title: title,
        description: description,
        pretty: pretty
      )
    end

    # Generate Shale model from JSON Schema
    #
    # @param [Array<String>] schemas
    # @param [String, nil] root_name
    #
    # @return [Array<String>]
    #
    # @example
    #   Shale::Schema.from_json([json_schema1, json_schema2], root_name: 'foobar')
    #   # => [model1, model2, model3]
    #
    # @api public
    def self.from_json(schemas, root_name: nil)
      JSONCompiler.new.to_models(schemas, root_name: root_name)
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
      XMLGenerator.new.to_schemas(klass, base_name, pretty: pretty, declaration: declaration)
    end

    # Generate Shale model from XML Schema
    #
    # @param [Array<String>] schemas
    # @param [<String>] ruby_namespace
    #
    # @return [Array<String>]
    #
    # @example
    #   Shale::Schema.from_xml([xml_schema1, xml_schema2])
    #   # => [model1, model2, model3]
    #
    # @api public
    def self.from_xml(schemas, ruby_namespace: nil)
      XMLCompiler.new.to_models(schemas, ruby_namespace: ruby_namespace)
    end
  end
end
