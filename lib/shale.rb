# frozen_string_literal: true

require 'yaml'

require_relative 'shale/mapper'
require_relative 'shale/adapter/json'
require_relative 'shale/type'
require_relative 'shale/type/boolean'
require_relative 'shale/type/date'
require_relative 'shale/type/float'
require_relative 'shale/type/integer'
require_relative 'shale/type/string'
require_relative 'shale/type/time'
require_relative 'shale/version'

# Main library namespace
#
# Shale uses adapters for parsing and serializing documents.
# For handling JSON, YAML, TOML and CSV, adapter must implement .load and .dump methods, so
# e.g for handling JSON, MultiJson works out of the box.
#
# Adapters for XML handling are more complicated and must conform to [@see shale/adapter/rexml]
# Shale provides adaters for most popular XML parsing libraries:
# Shale::Adapter::REXML, Shale::Adapter::Nokogiri and Shale::Adapter::Ox
#
# By default Shale::Adapter::REXML is used so no external dependencies are needed, but it's
# not as performant as Nokogiri or Ox, so you may want to change it.
#
# @example setting MultiJSON for handling JSON documents
#   Shale.json_adapter = MultiJson
#   Shale.json_adapter # => MultiJson
#
# @example setting TOML adapter for handling TOML documents
#   require 'shale/adapter/toml_rb'
#
#   Shale.toml_adapter = Shale::Adapter::TomlRB
#   Shale.toml_adapter # => Shale::Adapter::TomlRB
#
# @example setting REXML adapter for handling XML documents
#   Shale.xml_adapter = Shale::Adapter::REXML
#   Shale.xml_adapter # => Shale::Adapter::REXML
#
# @example setting Nokogiri adapter for handling XML documents
#   require 'shale/adapter/nokogiri'
#
#   Shale.xml_adapter = Shale::Adapter::Nokogir
#   Shale.xml_adapter # => Shale::Adapter::Nokogir
#
# @example setting Ox adapter for handling XML documents
#   require 'shale/adapter/ox'
#
#   Shale.xml_adapter = Shale::Adapter::Ox
#   Shale.xml_adapter # => Shale::Adapter::Ox
#
# @example setting CSV adapter for handling CSV documents
#   require 'shale/adapter/csv'
#
#   Shale.csv_adapter = Shale::Adapter::CSV
#   Shale.csv_adapter # => Shale::Adapter::CSV
#
# @api public
module Shale
  class << self
    # Set JSON adapter
    #
    # @param [.load, .dump] adapter
    #
    # @example
    #   Shale.json_adapter = Shale::Adapter::JSON
    #
    # @api public
    attr_writer :json_adapter

    # Set YAML adapter
    #
    # @param [.load, .dump] adapter
    #
    # @example
    #   Shale.yaml_adapter = YAML
    #
    # @api public
    attr_writer :yaml_adapter

    # TOML adapter accessor. Available adapters are Shale::Adapter::Tomlib
    # and Shale::Adapter::TomRB
    #
    # @param [@see Shale::Adapter::Tomlib] adapter
    #
    # @example setting adapter
    #   Shale.toml_adapter = Shale::Adapter::Tomlib
    #
    # @example getting adapter
    #   Shale.toml_adapter
    #   # => Shale::Adapter::Tomlib
    #
    # @api public
    attr_accessor :toml_adapter

    # Set CSV adapter
    #
    # @param [.load, .dump] adapter
    #
    # @example setting adapter
    #   Shale.csv_adapter = Shale::Adapter::CSV
    #
    # @example getting adapter
    #   Shale.csv_adapter
    #   # => Shale::Adapter::CSV
    #
    # @api public
    attr_accessor :csv_adapter

    # XML adapter accessor. Available adapters are Shale::Adapter::REXML,
    # Shale::Adapter::Nokogiri and Shale::Adapter::Ox
    #
    # @param [@see Shale::Adapter::REXML] adapter
    #
    # @example setting adapter
    #   Shale.xml_adapter = Shale::Adapter::REXML
    #
    # @example getting adapter
    #   Shale.xml_adapter
    #   # => Shale::Adapter::REXML
    #
    # @api public
    attr_accessor :xml_adapter

    # Return JSON adapter. By default Shale::Adapter::JSON is used
    #
    # @return [.load, .dump]
    #
    # @example
    #   Shale.json_adapter
    #   # => Shale::Adapter::JSON
    #
    # @api public
    def json_adapter
      @json_adapter || Adapter::JSON
    end

    # Return YAML adapter. By default YAML is used
    #
    # @return [.load, .dump]
    #
    # @example
    #   Shale.yaml_adapter
    #   # => YAML
    #
    # @api public
    def yaml_adapter
      @yaml_adapter || YAML
    end
  end
end
