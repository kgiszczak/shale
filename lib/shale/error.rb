# frozen_string_literal: true

module Shale
  # Error message displayed when TOML adapter is not set
  # @api private
  TOML_ADAPTER_NOT_SET_MESSAGE = <<~MSG
    TOML Adapter is not set.
    To use Shale with TOML documents you have to install parser and set adapter.

    # To use Tomlib:
    # Make sure tomlib is installed eg. execute: gem install tomlib
    Shale.toml_adapter = Tomlib

    # To use toml-rb:
    # Make sure toml-rb is installed eg. execute: gem install toml-rb
    require 'shale/adapter/toml_rb'
    Shale.toml_adapter = Shale::Adapter::TomlRB
  MSG

  # Error message displayed when XML adapter is not set
  # @api private
  XML_ADAPTER_NOT_SET_MESSAGE = <<~MSG
    XML Adapter is not set.
    To use Shale with XML documents you have to install parser and set adapter.

    # To use REXML:
    require 'shale/adapter/rexml'
    Shale.xml_adapter = Shale::Adapter::REXML

    # To use Nokogiri:
    # Make sure Nokogiri is installed eg. execute: gem install nokogiri
    require 'shale/adapter/nokogiri'
    Shale.xml_adapter = Shale::Adapter::Nokogiri

    # To use OX:
    # Make sure Ox is installed eg. execute: gem install ox
    require 'shale/adapter/ox'
    Shale.xml_adapter = Shale::Adapter::Ox
  MSG

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

  # Error for passing incorrect model type
  #
  # @api private
  class IncorrectModelError < StandardError
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

  # Schema compilation error
  #
  # @api private
  class SchemaError < StandardError
  end

  # Parsing error
  #
  # @api private
  class ParseError < StandardError
  end

  # Adapter error
  #
  # @api private
  class AdapterError < StandardError
  end
end
